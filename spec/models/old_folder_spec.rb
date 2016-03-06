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

  describe "OldFolder validations" do
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
  end

  describe "Basic OldFolder Searches" do

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

    it "returns the correct result when searching for something with spaces" do
      expect(OldFolder.search("Tit le 2")).to match_array([@o2])
    end
  end

  describe "OldFolder Search with Umlauts" do
    it "finds Übersetzer when searching über" do
      @o1 = FactoryGirl.build(:old_folder, title: "Übersetzer")
      @o1.save!

      expect(OldFolder.search("über")).to match_array([@o1])

      @o1.destroy!
    end
  end

  describe "OldFolder color handling" do
    it "returns the correct css-color" do
      expect(FactoryGirl.build(:old_folder, color: :black).css_color
      ).to eq("#000")
      expect(FactoryGirl.build(:old_folder, color: :red).css_color
      ).to eq("#f00")
      expect(FactoryGirl.build(:old_folder, color: :blue).css_color
      ).to eq("#00f")
      expect(FactoryGirl.build(:old_folder, color: :green).css_color
      ).to eq("#0f0")
    end

  end

  describe "contains_written_exams?" do
    it 'returns true for contentType=Klausurordner' do
      exam = FactoryGirl.build(:old_folder, contentType: 'Klausurordner')
      expect(exam.contains_written_exams?).to eq(true)
    end

    it 'returns true for contentType=Klausurmappe' do
      exam = FactoryGirl.build(:old_folder, contentType: 'Klausurmappe')
      expect(exam.contains_written_exams?).to eq(true)
    end

    it 'returns false for contentType=Prüfungsprotokollordner' do
      exam = FactoryGirl.build(:old_folder, contentType: 'Prüfungsprotokollordner')
      expect(exam.contains_written_exams?).to eq(false)
    end

    it 'returns false for contentType=Prüfungsprotokollmappe' do
      exam = FactoryGirl.build(:old_folder, contentType: 'Prüfungsprotokollmappe')
      expect(exam.contains_written_exams?).to eq(false)
    end

    it 'returns false for contentType=Übungsblätter' do
      exam = FactoryGirl.build(:old_folder, contentType: 'Übungsblätter')
      expect(exam.contains_written_exams?).to eq(false)
    end

    it 'returns false for contentType=Sonstiges' do
      exam = FactoryGirl.build(:old_folder, contentType: 'Sonstiges')
      expect(exam.contains_written_exams?).to eq(false)
    end


  end
end