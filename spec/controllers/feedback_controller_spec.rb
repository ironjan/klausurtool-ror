require 'rails_helper'

RSpec.describe FeedbackController, type: :controller do

  describe "GET #feedback_form" do
    it "returns http success" do
      get :feedback_form
      expect(response).to have_http_status(:success)
    end
  end

end
