require 'rails_helper'

describe AusleiheController do
  it 'reminds me to implement spec for this controller'

  describe 'index' do
    it 'renders the correct template on get' do
      get :index
      expect(response).to render_template("ausleihe/index")
    end
  end


  describe 'lent' do
    it 'renders the correct template on get' do
      get :lent
      expect(response).to render_template("ausleihe/lent")
    end
  end

  describe 'history' do
    it 'renders the correct template on get' do
      get :history
      expect(response).to render_template("ausleihe/history")
    end
  end

  describe 'folders' do
    it 'renders the correct template on get' do
      get :folders
      expect(response).to render_template("ausleihe/folders")
    end
  end

  describe 'folder_details' do
    it 'renders the correct template on get' do
      get :folder_details, params: { id: -1 }
      expect(response).to render_template("ausleihe/folder_details")
    end
  end

  describe 'exams' do
    it 'renders the correct template on get' do
      get :exams
      expect(response).to render_template("ausleihe/exams")
    end
  end

  describe 'switch' do
    it 'reminds me to implements specs'
  end

  describe 'lending_form' do
    it 'redirects to ausleihe_path when no old_folder_instances are given' do
      get :lending_form
      expect(response).to redirect_to :action => :index
    end

    it 'redirects to ausleihe_path if some old_folder_instances cannot be found'
    it 'renders the correct template when given old_folder_instances'

    end

  describe 'lending_action' do
    it 'renders lending_form on invalid input' do
      post :lending_action
      expect(response).to render_template("ausleihe/lending_form")
    end

    it 'redirects to ausleihe_path and shows success message when everything worked'
  end

  describe 'returning_form' do
    it 'redirects to ausleihe_path if no lent folders are given' do
      get :returning_form
      expect(response).to redirect_to :action => :index
    end

    it 'redirects to ausleihe_path if some old_folder_instances cannot be found'
    it 'rejects input from two different lending actions'
    it 'renders the correct template on get with lent folders given'
  end

  describe 'returning_action' do

    it 'renders returning_form on invalid input' do
      post :returning_action
      expect(response).to render_template("ausleihe/returning_form")
    end

    it 'redirects to ausleihe_path and shows success message when everything worked'

  end

end
