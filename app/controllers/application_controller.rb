# Provides an index page for the application
class ApplicationController < ActionController::Base
  include PaginatedExamsList

  layout 'application'


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  	paginated_exams_list
  end
end
