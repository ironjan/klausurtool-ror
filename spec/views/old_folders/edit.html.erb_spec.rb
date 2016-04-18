require "spec_helper"

describe "old_folders/edit.html.erb" do
  describe "prevents regression for #168" do

    it "displays the correct value for old_folder.contentType" do
      old_folder = FactoryGirl.build(:old_folder,
                                     contentType: 'Prüfungsprotokollmappe')

      assign(:old_folder, old_folder)

      render

      expect(rendered).to include('selected="selected" value="Prüfungsprotokollmappe"')
    end

    it "displays the correct value for old_folder.color" do
      old_folder = FactoryGirl.build(:old_folder,
                                     color: :green)

      assign(:old_folder, old_folder)

      render

      expect(rendered).to include('selected="selected" value="green"')
    end

    it "displays the correct value for old_folder.area" do
      old_folder = FactoryGirl.build(:old_folder,
                                     area: 'Sonstiges')

      assign(:old_folder, old_folder)

      render

      expect(rendered).to include('selected="selected" value="Sonstiges"')
    end
  end
end