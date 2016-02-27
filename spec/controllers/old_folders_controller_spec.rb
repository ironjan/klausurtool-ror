require 'rails_helper'

describe OldFoldersController do

  describe "prevents regression for #86"
  it "does not crash with NoMethodError on list_broken_encodings" do
    get :list_broken_encodings
    expect(response).to render_template("old_folders/list_broken_encodings")
  end
end
