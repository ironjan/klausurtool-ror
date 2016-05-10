require 'rails_helper'

RSpec.describe Internal::InternalApplicationController, type: :controller do
  describe 'index' do
    it 'renders the correct template' do
      get :index
      expect(response).to render_template("internal/internal_application/index")
    end
  end

end