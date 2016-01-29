require 'rails_helper'

describe OldExam do

  it "has a valid factory" do
    expect(FactoryGirl.create(:old_exam)).to be_valid
  end

  it "cannot have empty date" do
    expect(FactoryGirl.build(:old_exam, date: nil)).to_not be_valid
  end

  it "cannot have an invalid date 0000-00-00" do
    expect(FactoryGirl.build(:old_exam, date: "0000-00-00")).to_not be_valid
  end

  it "cannot have an invalid date 2015-00-00" do
    expect(FactoryGirl.build(:old_exam, date: "2015-00-00")).to_not be_valid
  end

  it "cannot have an invalid date 2015-12-00" do
    expect(FactoryGirl.build(:old_exam, date: "2015-15-00")).to_not be_valid
  end

  it "cannot have empty title" do
    expect(FactoryGirl.build(:old_exam, title: nil)).to_not be_valid
  end

  it "cannot have empty examiners" do
    expect(FactoryGirl.build(:old_exam, examiners: nil)).to_not be_valid
  end

  it "returns all on empty search"


  it "searches for exact date"
  it "searches for partly match title"
  it "searches for partly match examinars"
end