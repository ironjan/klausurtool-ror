require "spec_helper"

describe "internal/admin/print/toc.html.erb" do
  it "displays the " do
    old_folder = FactoryGirl.build(:old_folder, title: "My Name")
    assign(:old_folder, old_folder)
    assign(:unarchived_exams, [])
    render

    expect(rendered).to include('Ordner: My Name')
  end
end