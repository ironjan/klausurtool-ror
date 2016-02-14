require 'rails_helper'

describe OldExamsController do
  it "reminds me to implement spec for this controller"
  describe "GET index" do
    it "renders the correct template" do
      get :index
      expect(response).to render_template("old_exams/index")
    end

    it "clears search when reset is sent" do
      get :index, :search => "not empty", :reset => "reset"
      expect(response).to render_template("old_exams/index")
      expect(controller.params[:sort]).to be(nil)
    end

  end

end
