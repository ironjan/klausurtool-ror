# TODO is this Mailer needed?
class ApplicationMailer < ActionMailer::Base #:nodoc:
  default from: "noreply@ausleihe.fachschafts.website"
  layout 'mailer'
end
