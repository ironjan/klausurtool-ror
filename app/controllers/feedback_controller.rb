class FeedbackController < ApplicationController
  layout 'ausleihe', except: 'error'

  def feedback_form
    nyi
    source_page = params[:source_page]
    if source_page.nil?
      @source_page = 'Keine Seite angegeben'
    else
      @source_page = source_page
    end
  end

  def send_feedback
    nyi
    render 'feedback_form'
  end

  private
  def nyi
    flash[:warning] = 'Noch nicht implementiert. Feedback wird nicht abgesendet.'
  end
end
