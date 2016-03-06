require 'rails_helper'


describe OldExamsHelper do
  describe 'existing_titles' do
    it 'returns an empty array, if no titles are found' do
      expect(OldExamsHelper.existing_titles).to match([])
    end
  end

  describe 'existing_examiners' do
    it 'returns an empty array, if no examiners are found' do
      expect(OldExamsHelper.existing_examiners).to match([])
    end
  end
end
