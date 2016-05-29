# TODO is this Mailer needed?
class ApplicationMailer < ActionMailer::Base
  default from: "noreply@ausleihe.fachschafts.website"
  layout 'mailer'
end
