require 'rails_helper'

describe OldExamsController do
  it "reminds me to implement spec for this controller"
  describe "index" do
    it "renders the correct template" do
      get :index
      expect(response).to render_template("old_exams/index")
    end

    it "clears search when reset is sent" do
      get :index, params: { :search => "not empty", :reset => "reset" }
      expect(response).to render_template("old_exams/index")
      expect(controller.params[:sort]).to be(nil)
    end

  end

  describe "create" do
    it "shows new when called without parameters" do
      post :create
      expect(response).to render_template(:new)
    end

    it "shows 'Ordner nicht gefunden' for non-existing folders" do
      post :create, params: { old_folder_id: -1 }
      expect(response).to render_template(:new)
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq('Ordner nicht gefunden.')
    end

    it "redirects to folder when creation succeeded"
  end

  describe "new" do

    it "shows error if it is tried to create an exam in a non-existing folder" do
      get :new, params: { old_folder_id: -1 }
      expect(response).to render_template("old_exams/new")
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq('Ordner nicht gefunden.')
    end

    it "renders form when given and existing folder"
  end

  describe "edit" do
    it "reminds me to implement this spec"
    it "loads the edit template"
  end

  describe "show" do
    it "reminds me to implement this spec"
  end

  describe "update" do
    it "reminds me to implement this spec"
  end

  describe "destroy" do
    it "reminds me to implement this spec"
  end

end
