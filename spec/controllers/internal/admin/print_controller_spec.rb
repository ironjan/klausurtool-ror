require 'rails_helper'

RSpec.describe Internal::Admin::PrintController, type: :controller do
  describe 'cover' do
    it 'shows an alert, if no barcode is given' do
      get :cover, barcode: ''
      expect(response).to render_template("internal/admin/print/cover")
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq('Kein Ordner-Exemplar angegeben.')
    end

    it 'shows an alert, if no folder_instance with the given barcode exists' do
      get :cover, barcode: -1
      expect(response).to render_template("internal/admin/print/cover")
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq('Ordner-Exemplar mit Barcode `-1` nicht gefunden.')
    end

    it 'renders the toc template when requested for a valid folder' do
      folder = FactoryGirl.create(:old_folder)
      FactoryGirl.create(:old_folder_instance, old_folder: folder, barcodeId: 9999)

      get :cover, barcode: 9999
      expect(response).to render_template("internal/admin/print/cover")
    end
  end

  describe 'toc' do

    it 'shows an alert when no id is given' do
      get :toc, old_folder_id: ''
      expect(response).to render_template("internal/admin/print/toc")
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq('Kein Ordner angegeben.')
    end

    it 'shows an alert when requested for an invalid folder' do
      get :toc, old_folder_id: -1
      expect(response).to render_template("internal/admin/print/toc")
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq('Ordner mit Id `-1` nicht gefunden.')
    end

    it 'shows a warning when the folder contains too many exams' do
      folder = FactoryGirl.create(:old_folder)

      number_of_exams = 40
      while number_of_exams > 0
        FactoryGirl.create(:old_exam, old_folder_id: folder.id)
        number_of_exams -= 1
      end

      get :toc, old_folder_id: folder.id
      expect(response).to render_template("internal/admin/print/toc")
      expect(flash[:warning]).to be_present
      expect(flash[:warning]).to eq('Es können nicht alle Prüfungen auf eine Seite gedruckt werden. Bitte einige Klausuren archivieren oder auslaugern.')

    end

    it 'renders the toc template when requested for a valid folder' do
      folder = FactoryGirl.create(:old_folder)
      exam_1 = FactoryGirl.create(:old_exam, old_folder_id: folder.id)

      get :toc, old_folder_id: folder.id
      expect(response).to render_template("internal/admin/print/toc")

      exam_1.destroy!
      folder.destroy!
    end
  end
end
