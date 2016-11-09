require 'rails_helper'

describe ReminderMailsHelper do

  describe 'recipient' do
    it 'return the imt-name with appended mail suffix' do
      expect(recipient(FactoryGirl.build(:old_lend_out, imt: 'nil'))).to eq('nil@mail.upb.de')
      expect(recipient(FactoryGirl.build(:old_lend_out, imt: 'abc'))).to eq('abc@mail.upb.de')
      expect(recipient(FactoryGirl.build(:old_lend_out, imt: 'ljan'))).to eq('ljan@mail.upb.de')
    end
  end

  describe 'subject' do
  	it 'returns the correct subject' do
  	  expect(subject()).to eq('[Klausurausleihe] Verliehene Ordner/Mappen zeitnah zurückbringen')
  	end
  end

  describe 'cc' do
  	it 'reminds me to spec' do
  	  expect(cc()).to eq('fsmi@upb.de; fsmi-klausurarchiv@lists.upb.de')
    end
  end

  describe 'body' do
  	it 'reminds me to spec'
  end
end