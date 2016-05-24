require 'rails_helper'


describe ImtToNameHelper do
  describe "#name_for_login" do
    it "returns 'Keine Verbindung zum LDAP' when there's no LDAP connection" do
      ldap = double("Net::LDAP", :bind => false)
      expect(name_for_login('', ldap)).to eq('Keine Verbindung zum LDAP')
    end

    it "returns 'Name für $imtLogin nicht gefunden' when there's no match" do
      ldap = double("Net::LDAP", :bind => true, :search => [])
      imt_login = 'no_match'
      expect(name_for_login(imt_login, ldap)).to eq("Name für #{imt_login} nicht gefunden")
    end

    it 'returns a single name for a single match' do
      mock_result = [double('Net::LDAP::Entry', :gecos => ['Real Name'])]
      ldap = double('Net::LDAP', :bind => true, :search => mock_result)
      imt_login = 'one match'
      expect(name_for_login(imt_login, ldap)).to eq('Real Name')
    end

    it "returns 'Fehler: mehr als ein Name gefunden' if there is more than one match" do
      # This should not happen because every person has a unique login...

      mock_result = [double('Net::LDAP::Entry', :gecos => ['Real Name']), double('Net::LDAP::Entry', :gecos => ['Second Name'])]
      ldap = double('Net::LDAP', :bind => true, :search => mock_result)
      expect(name_for_login('one match', ldap)).to eq('Fehler: mehr als ein Name gefunden')

    end

    it "returns 'Keine Verbindung zum LDAP' if there is a NoBindResultError" do
      ldap = double(:bind => true)
      allow(ldap).to receive(:search).and_raise(Errno::ECONNREFUSED)

      expect(name_for_login('', ldap)).to eq('Keine Verbindung zum LDAP')

    end

    it 'returns "Unbekannter LDAP Fehler" if there is any another exception' do
      ldap = double(:bind => true)
      allow(ldap).to receive(:search).and_raise('AnotherError')

      expect(name_for_login('', ldap)).to eq('Unbekannter LDAP Fehler')

    end
  end
end