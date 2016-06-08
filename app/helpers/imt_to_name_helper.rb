require 'net/ldap'

# This module encapsulates methods to get a person's real name from imt login
module ImtToNameHelper
  LDAP_UPB = Net::LDAP.new(host: 'ldap.uni-paderborn.de')

  # Gets the name for the imt login. Returns the error message on error. ldap is an optional parameter to allow injection.
  def name_for_login(imt_login, ldap = LDAP_UPB)
    begin
      unless ldap.bind
        return 'Keine Verbindung zum LDAP.'
      end

      ldap_search = do_ldap_search(imt_login, ldap)

      has_exactly_one_result = ldap_search.count == 1 && !ldap_search.first.nil?
      if has_exactly_one_result
        return ldap_search.first.gecos.first
      end

      Rails.logger.error("ImtToNameHelper: Multiple LDAP results for #{imt_login}")
    rescue Errno::ECONNREFUSED => e
      Rails.logger.error(e)
      return 'Keine Verbindung zum LDAP.'
    rescue => e
      Rails.logger.error(e)
    end
    'Fehler bei der LDAP-Suche.'
  end

  # Gets the name for the imt login. Returns nil on error. ldap is an optional parameter to allow injection.
  def name_or_nil_for_login(imt_login, ldap = LDAP_UPB)
    begin
      if ldap.bind
        ldap_search = do_ldap_search(imt_login, ldap)

        has_exactly_one_result = ldap_search.count == 1 && !ldap_search.first.nil?
        if has_exactly_one_result
          return ldap_search.first.gecos.first
        end
      end
    rescue Errno::ECONNREFUSED => e
      Rails.logger.error(e)
    rescue => e
      Rails.logger.error(e)
    end

    # default return value
    nil
  end

  def do_ldap_search(imt_login, ldap)
    ldap.search(
        base: 'o=upb,c=de',
        filter: Net::LDAP::Filter.eq("uid", imt_login)
    )
  end
end

