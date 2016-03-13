class FeedbackController < ApplicationController
  layout 'ausleihe', except: 'error'

  def feedback_form
    source_page = params[:source_page]
    if source_page.nil?
      @source_page = 'Keine Seite angegeben'
    else
      @source_page = source_page
    end
  end

  def send_feedback
    imt = params[:imt]
    comment = params[:comment]
    source_page = params[:source_page]
    if imt.nil?  || comment.nil?
      flash[:alert] = 'Nicht alle Pflicht-Parameter (IMT, Kommentar) übergeben.'
      render 'feedback_form' and return
    end
    FeedbackMailer.delay(run_at: 5.seconds.from_now).feedback_mail(imt, comment, source_page)
    render 'feedback_form'
  end

end
