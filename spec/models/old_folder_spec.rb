require 'rails_helper'

describe OldFolder do


  before(:each) do
    @o1 = FactoryGirl.build(:old_folder, title: "Title 1")
    @o2 = FactoryGirl.build(:old_folder, title: "Title 2")

    @o1.save!
    @o2.save!
  end

  after(:each) do
    @o1.destroy!
    @o2.destroy!
  end

  it "has a valid factory" do
    expect(FactoryGirl.build(:old_folder)).to be_valid
  end

  it "is not valid without title" do
    expect(FactoryGirl.build(:old_folder, title: nil)).to_not be_valid
  end

  it "is not valid without contentType" do
    expect(FactoryGirl.build(:old_folder, contentType: nil)).to_not be_valid
  end

  it "is not valid without color" do
    expect(FactoryGirl.build(:old_folder, color: nil)).to_not be_valid
  end

  it "is not valid without area" do
    expect(FactoryGirl.build(:old_folder, area: nil)).to_not be_valid
  end

  it "is not valid with a contentType that's not allowed" do
    expect(FactoryGirl.build(:old_folder, contentType: "Wrong Type")).to_not be_valid
  end

  it "is not valid with an area that's not allowed" do
    expect(FactoryGirl.build(:old_folder, area: "No Area")).to_not be_valid
  end

  it "returns everything for empty search" do
    expect(OldFolder.search('')).to match_array([@o1, @o2])
  end

  it "returns no results for search matching nothing" do
    expect(OldFolder.search("Title 3")).to match_array([])
  end

  it "returns 1 result for search matching exactly one folder" do
    expect(OldFolder.search("Title 1")).to match_array([@o1])
  end

  it "returns 2 results for search matching 2 folders" do
    expect(OldFolder.search("Title")).to match_array([@o1, @o2])
  end
end