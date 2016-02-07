require 'net/ldap'

module ImtToNameHelper
  LDAP_UPB = Net::LDAP.new(host: 'ldap.uni-paderborn.de')

  # Gets the name for the imt login. ldap is an optional parameter to allow injection.
  def name_for_login(imt_login, ldap = LDAP_UPB)
    begin
      if ldap.bind
        ldap_search = ldap.search(
            base: 'o=upb,c=de',
            filter: Net::LDAP::Filter.eq("uid", imt_login)
        )

        return 'Fehler: mehr als ein Name gefunden' if ldap_search.count > 1

        first_result = ldap_search.first
        if first_result.nil?
          "Name für #{imt_login} nicht gefunden"
        else
          first_result.gecos.first
        end
      else
        "Keine Verbindung zum LDAP"
      end
    rescue Net::LDAP::NoBindResultError => e
      Rails.logger.error(e)
      'Keine Verbindung zum LDAP'
    rescue Exception => e
      Rails.logger.error(e)
      'Unbekannter LDAP Fehler'
    end
  end
end

