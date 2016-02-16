require 'rails_helper'

EXAMINERS_FOO_BAR = "Foo Bar"
EXAMINERS_FOO = "Foo"
EXAMINERS_BAR = "Bar"

DATE_2015_12_21 = "2015-12-21 00:00:00"
DATE_2015_12_22 = "2015-12-22 00:00:00"

TITLE_TIT_LE = "Tit le"
TITLE_EXAM_TITLE = "Exam Title"
TITLE_PRUEFUNG = "Prüfung"


describe OldExam do

  before(:each) do
    old_folder = FactoryGirl.build(:old_folder)
    @exam1 = OldExam.create(examiners: EXAMINERS_FOO_BAR, date: DATE_2015_12_21, title: TITLE_TIT_LE, old_folder: old_folder)
    @exam2 = OldExam.create(examiners: EXAMINERS_FOO, date: DATE_2015_12_22, title: TITLE_EXAM_TITLE, old_folder: old_folder)
    @exam3 = OldExam.create(examiners: EXAMINERS_BAR, date: DATE_2015_12_22, title: TITLE_PRUEFUNG, old_folder: old_folder)

    @exam1.save!
    @exam2.save!
    @exam3.save!
  end

  after(:each) do
    @exam1.destroy!
    @exam2.destroy!
    @exam3.destroy!
  end

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

  it "returns everything for empty search" do
    expect(OldExam.search('')).to match_array([@exam1, @exam2, @exam3])
  end

  it "returns empty array for non-matching search" do
    expect(OldExam.search("2012-12-20")).to match_array([])
  end

  it "finds 1 element for date search matching 1 element" do
    expect(OldExam.search("2015-12-21")).to match_array([@exam1])
    expect(OldExam.search("2015-12-22")).to match_array([@exam2, @exam3])
  end

  it "finds 2 elements for date search matching 2 elements" do
    expect(OldExam.search("2015-12-22")).to match_array([@exam2, @exam3])
  end

  it "finds 3 elements for partly date search matching 3 elements" do
    expect(OldExam.search("2015-12")).to match_array([@exam1, @exam2, @exam3])
  end

  it "finds 1 match for title search matching 1 element" do
    expect(OldExam.search(TITLE_PRUEFUNG)).to match([@exam3])
  end

  it "finds 2 matches for title search matching 2 elements" do
    expect(OldExam.search(TITLE_TIT_LE)).to match([@exam1, @exam2])
  end


  it "finds 1 match for examiners search matching 1 element" do
    expect(OldExam.search(EXAMINERS_FOO_BAR)).to match([@exam1])
  end

  it "finds 2 matches for examiners search matching 2 elements" do
    expect(OldExam.search(EXAMINERS_FOO)).to match([@exam1, @exam2])
    expect(OldExam.search(EXAMINERS_BAR)).to match([@exam1, @exam3])
  end
end