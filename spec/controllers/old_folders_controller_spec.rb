require 'rails_helper'

describe OldFoldersController do

  describe "prevents regression for #86"
  it "does not crash with NoMethodError on list_broken_encodings" do
    controller = FactoryGirl.build(:old_folders_controller)
    controller.list_broken_encodings
  end
end
