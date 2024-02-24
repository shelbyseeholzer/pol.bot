class HomeController < ApplicationController
  def index
    # This is the index function/ method
    @subscriber = Subscriber.new
  end
end
