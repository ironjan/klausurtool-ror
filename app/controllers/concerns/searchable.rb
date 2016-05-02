# Provides a method to clear params[:search] when params[:reset] is received
module Searchable
  extend ActiveSupport::Concern

  def clear_search_on_reset
    if params[:reset]
      params[:search] = nil
    end
  end
end