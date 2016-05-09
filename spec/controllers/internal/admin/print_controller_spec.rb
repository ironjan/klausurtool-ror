require 'rails_helper'

RSpec.describe Internal::Admin::PrintController, type: :controller do
  describe 'cover' do
    it 'reminds me to be implemented'
  end

  describe 'toc' do

    it 'renders an error message when requested for an invalid folder' do
      get :toc, old_folder_id: -1
      expect(response).to render_template("internal/admin/print/toc")
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq('Ordner mit Id `-1` nicht gefunden.')
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
