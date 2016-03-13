class FeedbackMailer < ApplicationMailer

  def feedback_mail(imt, comment, source_page)
    @comment = comment
    @source_page = source_page
    foo = mail(to: 'ljan@mail.upb.de', cc: imt+'@mail.upb.de', subject: 'Feedback')
    Rails.logger.warn("#{foo.inspect}")
    foo
  end

end
