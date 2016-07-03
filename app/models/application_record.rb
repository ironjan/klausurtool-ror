# Since Rails 5.0, ApplicationRecord is a new superclass for all app models, analogous to
# app controllers subclassing ApplicationController instead of ActionController::Base.
# This gives apps a single spot to configure app-wide model behavior.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

