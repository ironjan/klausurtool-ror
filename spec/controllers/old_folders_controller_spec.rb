require 'rails_helper'

describe OldFoldersController do

  describe "prevents regression for #86"
  it "does not crash with NoMethodError on list_broken_encodings" do
    get :list_broken_encodings
    expect(response).to render_template("old_folders/list_broken_encodings")
  end

  describe 'toc' do
    it 'renders an error message when requested without folder' do
      get :toc
      expect(response).to render_template("old_folders/toc")
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq('Kein Ordner angegeben.')
    end

    it 'renders an error message when requested for an invalid folder' do
      get :toc, old_folder_id: -1
      expect(response).to render_template("old_folders/toc")
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq('Ordner mit Id `-1` nicht gefunden.')
    end

    it 'renders the toc template when requested for a valid folder' do
      folder = FactoryGirl.build(:old_folder)
      folder.save!
      exam_1 = FactoryGirl.build(:old_exam, old_folder_id: folder.id)
      exam_1.save!
      exam_2 = FactoryGirl.build(:old_exam, old_folder_id: folder.id)
      exam_2.save!
      exam_3 = FactoryGirl.build(:old_exam, old_folder_id: folder.id)
      exam_3.save!

      get :toc, old_folder_id: folder.id
      expect(response).to render_template("old_folders/toc")
      # FIXME expect response to contain...

      folder.destroy!
      exam_1.destroy!
      exam_2.destroy!
      exam_3.destroy!

          fail
    end
  end
end
