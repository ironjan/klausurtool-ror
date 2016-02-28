require "spec_helper"

describe "old_folders/toc.html.erb" do
  it "displays the " do
    old_folder = FactoryGirl.build(:old_folder, title: "My Name")
    assign(:old_folder, old_folder)

    render

    expect(rendered).to include('Ordner: My Name')
  end
end