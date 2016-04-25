require 'rails_helper'

EXAMINERS_FOO_BAR = 'Foo Bar'
EXAMINERS_FOO = 'Foo'
EXAMINERS_BAR = 'Bar'

DATE_2015_12_21 = '2015-12-21 00:00:00'
DATE_2015_12_22 = '2015-12-22 00:00:00'

TITLE_EXAM_TITLE = 'Exam Title'
TITLE_PRUEFUNG = 'Prüfung'
TITLE_TIT_LE = 'Tit le'


describe OldExam do
  describe 'Validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.build(:old_exam)).to be_valid
    end

    it 'cannot have empty date' do
      expect(FactoryGirl.build(:old_exam, date: nil)).to_not be_valid
    end

    it 'cannot have empty title' do
      expect(FactoryGirl.build(:old_exam, title: nil)).to_not be_valid
    end

    it 'cannot have empty examiners' do
      expect(FactoryGirl.build(:old_exam, examiners: nil)).to_not be_valid
    end
  end
  
  describe 'Search functions' do

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

    it 'returns everything for empty search' do
      expect(OldExam.search('')).to match_array([@exam1, @exam2, @exam3])
    end

    it 'returns empty array for non-matching search' do
      expect(OldExam.search('2012-12-20')).to match_array([])
    end

    it 'finds 1 element for date search matching 1 element' do
      expect(OldExam.search('2015-12-21')).to match_array([@exam1])
      expect(OldExam.search('2015-12-22')).to match_array([@exam2, @exam3])
    end

    it 'finds 2 elements for date search matching 2 elements' do
      expect(OldExam.search('2015-12-22')).to match_array([@exam2, @exam3])
    end

    it 'finds 3 elements for partly date search matching 3 elements' do
      expect(OldExam.search('2015-12')).to match_array([@exam1, @exam2, @exam3])
    end

    it 'finds 1 match for title search matching 1 element' do
      expect(OldExam.search(TITLE_PRUEFUNG)).to match_array([@exam3])
    end

    it 'finds 2 matches for title search matching 2 elements' do
      expect(OldExam.search(TITLE_TIT_LE)).to match_array([@exam1, @exam2])
    end


    it 'finds 1 match for examiners search matching 1 element' do
      expect(OldExam.search(EXAMINERS_FOO_BAR)).to match_array([@exam1])
    end

    it 'finds 2 matches for examiners search matching 2 elements' do
      expect(OldExam.search(EXAMINERS_FOO)).to match_array([@exam1, @exam2])
      expect(OldExam.search(EXAMINERS_BAR)).to match_array([@exam1, @exam3])
    end
  end

  describe 'Auto-Completion functions for filled db' do
    describe 'existing_titles' do
      it 'returns an empty array, if no titles are found' do
      expect(OldExam.existing_titles).to match_array([])
      end
    end

    describe 'existing_examiners' do
      it 'returns an empty array, if no examiners are found' do
      expect(OldExam.existing_examiners).to match_array([])
      end
    end
  end

  describe 'Auto-Completion functions for filled db' do

    def build_autocompletion_test_data
      old_folder = FactoryGirl.build(:old_folder)
      @exam1 = OldExam.create(examiners: EXAMINERS_FOO_BAR, date: DATE_2015_12_21, title: TITLE_TIT_LE, old_folder: old_folder)
      @exam2 = OldExam.create(examiners: EXAMINERS_FOO, date: DATE_2015_12_22, title: TITLE_EXAM_TITLE, old_folder: old_folder)
      @exam3 = OldExam.create(examiners: EXAMINERS_BAR, date: DATE_2015_12_22, title: TITLE_PRUEFUNG, old_folder: old_folder)

      @exam1.save!
      @exam2.save!
      @exam3.save!
    end

    def destroy_autocompletion_test_data
      @exam1.destroy!
      @exam2.destroy!
      @exam3.destroy!
    end

    describe 'existing_titles' do
      it 'returns the titles if there are titles' do
        build_autocompletion_test_data
        expect(OldExam.existing_titles).to match_array([TITLE_EXAM_TITLE, TITLE_PRUEFUNG, TITLE_TIT_LE])
        destroy_autocompletion_test_data
      end
    end

    describe 'existing_examiners' do
      it 'returns the examiners if there are examiners' do
        build_autocompletion_test_data
        expect(OldExam.existing_examiners).to match_array([EXAMINERS_BAR, EXAMINERS_FOO, EXAMINERS_FOO_BAR])
        destroy_autocompletion_test_data
      end
    end
  end

end