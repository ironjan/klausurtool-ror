class FeedbackController < ApplicationController

  def index
    if params[:url]
      @feedback_url = params[:url]
    end
  end

  def send_feedback
    Rails.logger.debug("Params: #{params}")
    flash[:notice] = "#{Time.new}: Feedback versendet. Danke."
    render 'index'
  end
end