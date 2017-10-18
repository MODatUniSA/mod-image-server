class ImageChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    # stream_from "image_#{params[:page]}"
    # TODO: limit this to the home page
    stream_for "image_home"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
