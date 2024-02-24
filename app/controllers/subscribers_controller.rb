class SubscribersController < ApplicationController
  def create
    @subscriber = Subscriber.new(subscriber_params)
    if @subscriber.save
      # Handle a successful save
      # format.turbo_stream do
      #   render turbo_stream: turbo_stream.replace('subscribe_form',
      #                                             partial: 'subscribers/form',
      #                                             locals: { notice: 'Thank you for subscribing!' })
      # end
      redirect_to root_path(anchor: 'new_subscriber'), notice: 'Thank you for subscribing!'
    else
      # Handle failure
      render :new
    end
  end

  def index
    @subscribers = Subscriber.all
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end
