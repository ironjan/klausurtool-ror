require 'rails_helper'

describe OldExamsController do
  it "reminds me to implement spec for this controller"
  describe "index" do
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

  describe "create" do
    it "shows new when called without parameters" do
      post :create
      expect(response).to render_template(:new)
    end

    it "shows 'Ordner nicht gefunden' for non-existing folders" do
      post :create, old_folder_id: -1
      expect(response).to render_template(:new)
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq('Ordner nicht gefunden.')
    end

    it "redirects to folder when creation succeeded"
  end

  describe "new" do

    it "shows error if it is tried to create an exam in a non-existing folder" do
      get :new, old_folder_id: -1
      expect(response).to render_template("old_exams/new")
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq('Ordner nicht gefunden.')
    end

    it "renders form when given and existing folder"
  end

  describe "edit" do
    it "reminds me to implement this spec"
    it "loads the edit template"

    it "shows a flash message for invalid dates" do
      invalid_date = '2015-00-00'
      exam = FactoryGirl.build(:old_exam, date: invalid_date)
      exam.save!

      get :edit, id: exam.id
      expect(response).to render_template("old_exams/edit")
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to match(/Datum in Datenbank (.*) ist fehlerhaft. Bitte das Datum korrigieren\./)

      exam.destroy!
    end
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
