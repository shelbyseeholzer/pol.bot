class DeviceMessageController < ApplicationController
  def create
    device_message = DeviceMessage.new(message_content: grab_message_params)
    #  accept message and put it in the database
    if device_message.save
      render json: device_message, status: :created
    else
      render json: device_message.errors, status: :unprocessable_entity
    end
  end

  def grab_message_params
    params.permit!
  end
end
