# DEVICE MESSAGE CONTROLLER
# This controller is responsible for accepting device messages and writing them to the database
# It also writes the device location message to the Hedera Smart Contract

class DeviceMessageController < ApplicationController
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
    contract_id = ENV['HEDERA_CONTRACT_ID']

    # get lat and long from the message
    rxInfo = _device_message.message_content['rxInfo'] # array of objects
    first = rxInfo[0]
    metadata = first['metadata']
    cheeseburger = metadata['gateway_long']
    gateway_lat = metadata['gateway_lat']

    deviceInfo = _device_message.message_content['deviceInfo']
    deviceId = deviceInfo['devEui']

    #  call setLocation with gateway lat and long and device id
    #    node_tasks/set_location/index.js
    #  CALL SETLOCATION WITH GATEWAY LAT AND LONG AND DEVICE ID

    setLocation(gas, newContractId, deviceId, gateway_lat, cheeseburger)
  end
end
