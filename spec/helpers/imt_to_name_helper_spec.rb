require 'rails_helper'


describe ImtToNameHelper do
  describe "common functionality of #name_for_login and #name_or_nil_for_login" do
    it 'returns a single name for a single match' do
      mock_result = [double('Net::LDAP::Entry', :gecos => ['Real Name'])]
      ldap = double('Net::LDAP', :bind => true, :search => mock_result)
      imt_login = 'one match'
      expect(name_for_login(imt_login, ldap)).to eq('Real Name')
      expect(name_or_nil_for_login(imt_login, ldap)).to eq('Real Name')
    end
  end

  describe "#name_for_login" do
    it "returns 'Keine Verbindung zum LDAP' when there's no LDAP connection" do
      ldap = double("Net::LDAP", :bind => false)
      expect(name_for_login('', ldap)).to eq('Keine Verbindung zum LDAP.')
    end

    it "returns 'Es konnte kein eindeutiger Name gefunden werden.' when there's no match" do
      ldap = double("Net::LDAP", :bind => true, :search => [])
      imt_login = 'no_match'
      expect(name_for_login(imt_login, ldap)).to eq('Fehler bei der LDAP-Suche.')
    end


    it "returns 'Fehler bei der LDAP-Suche.' if there is more than one match" do
      # This should not happen because every person has a unique login...
      mock_result = [double('Net::LDAP::Entry', :gecos => ['Real Name']), double('Net::LDAP::Entry', :gecos => ['Second Name'])]
      ldap = double('Net::LDAP', :bind => true, :search => mock_result)
      expect(name_for_login('one match', ldap)).to eq('Fehler bei der LDAP-Suche.')

    end

    it "returns 'Keine Verbindung zum LDAP.' if there is a NoBindResultError" do
      ldap = double(:bind => true)
      allow(ldap).to receive(:search).and_raise(Errno::ECONNREFUSED)

      expect(name_for_login('', ldap)).to eq('Keine Verbindung zum LDAP.')

    end

    it 'returns "Fehler bei der LDAP-Suche." if there is any another exception' do
      ldap = double(:bind => true)
      allow(ldap).to receive(:search).and_raise('AnotherError')

      expect(name_for_login('', ldap)).to eq('Fehler bei der LDAP-Suche.')

    end
  end

  describe "#name_or_nil_for_login" do
    it "returns nil when there's no LDAP connection" do
      ldap = double("Net::LDAP", :bind => false)
      expect(name_or_nil_for_login('', ldap)).to eq(nil)
    end

    it "returns nil when there's no match" do
      ldap = double("Net::LDAP", :bind => true, :search => [])
      imt_login = 'no_match'
      expect(name_or_nil_for_login(imt_login, ldap)).to eq(nil)
    end

    it "returns nil if there is more than one match" do
      # This should not happen because every person has a unique login...
      mock_result = [double('Net::LDAP::Entry', :gecos => ['Real Name']), double('Net::LDAP::Entry', :gecos => ['Second Name'])]
      ldap = double('Net::LDAP', :bind => true, :search => mock_result)
      expect(name_or_nil_for_login('one match', ldap)).to eq(nil)

    end

    it "returns nil if there is a NoBindResultError" do
      ldap = double(:bind => true)
      allow(ldap).to receive(:search).and_raise(Errno::ECONNREFUSED)

      expect(name_or_nil_for_login('', ldap)).to eq(nil)

    end

    it 'returns nil if there is any another exception' do
      ldap = double(:bind => true)
      allow(ldap).to receive(:search).and_raise('AnotherError')

      expect(name_or_nil_for_login('', ldap)).to eq(nil)

    end
  end
end
