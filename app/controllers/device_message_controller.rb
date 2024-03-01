# DEVICE MESSAGE CONTROLLER
# This controller is responsible for accepting device messages and writing them to the database
# It also writes the device location message to the Hedera Smart Contract

require 'eth'

class DeviceMessageController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    device_message = DeviceMessage.new(message_content: grab_message_params)
    #  accept message and put it in the sql database
    if device_message.save # saves to postgress-- the sql database
      write_to_hedera(device_message)
      render json: device_message, status: :created
    else
      render json: device_message.errors, status: :unprocessable_entity
    end
  end

  def grab_message_params
    params.permit!
  end

  def write_to_hedera(_device_message)
    # Need to write device location message to Hedera Smart Contract
    # get lat and long from the message
    rxInfo = _device_message.message_content['rxInfo'] # array of objects
    first = rxInfo[0]
    metadata = first['metadata']
    gateway_long = metadata['gateway_long']
    gateway_lat = metadata['gateway_lat']

    deviceInfo = _device_message.message_content['deviceInfo']
    deviceId = deviceInfo['devEui']

    set_location(deviceId, gateway_lat, gateway_long)
  end

  def set_location(_deviceId, _lat, _lng)
    # pass in setLocation(gas, newContractId, deviceId, lat, long)
    gas = 100_000
    new_contract_id = '0.0.3643101' # ENV['HEDERA_CONTRACT_ID']
    lat_int = convert_geo_string_to_int(_lat)
    lng_int = convert_geo_string_to_int(_lng)
    device_bytes32 = convert_string_to_keccak256(_deviceId)

    result = GoSetLocation.setLocation(gas, new_contract_id, device_bytes32, lat_int, lng_int, ENV['MY_ACCOUNT_ID'],
                                       ENV['MY_PRIVATE_KEY'])

    # Use the result in your Ruby code
    puts "Transaction status from JavaScript: #{result}"
  end

  def convert_int_to_geo_string(geo_int)
    (geo_int.to_f / 1e6).to_s
  end

  def convert_geo_string_to_int(geo_string)
    (geo_string.to_f * 1e6).to_i
  end

  def convert_string_to_keccak256(_string)
    # Compute the keccak256 hash of the device ID.
    hash_bytes = Eth::Util.keccak256(_string)

    # Convert the binary hash to a hexadecimal string.
    hash_bytes.unpack1('H*')
  end
end
