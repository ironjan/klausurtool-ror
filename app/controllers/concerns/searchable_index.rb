module SearchableIndex
  extend ActiveSupport::Concern

  def clear_search_on_reset
    if params[:reset]
      params[:search] = nil
    end
  end

  included do
    before_action :clear_search_on_reset, only: [:index]
  end
end