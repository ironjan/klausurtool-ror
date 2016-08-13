require 'rails_helper'

describe OldFolderInstancesController do
  it "reminds me to implement spec for this controller"

  describe '#destroy' do

    before(:each) do
      folder = FactoryGirl.create(:old_folder, id: 123)
    end

    it 'deleting a non-existent folder should throw 404' do
      expect {
        process :destroy, method: :delete, params: {old_folder_id: 123, id: -1}
      }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
