require 'net/ldap'

module ImtToNameHelper
  LDAP_UPB = Net::LDAP.new(host: 'ldap.uni-paderborn.de')

  # Gets the name for the imt login. Returns the error message on error. ldap is an optional parameter to allow injection.
  def name_for_login(imt_login, ldap = LDAP_UPB)
    begin
      if ldap.bind
        ldap_search = do_ldap_search(imt_login, ldap)

        has_exactly_one_result = ldap_search.count == 1 && !ldap_search.first.nil?
        if has_exactly_one_result
          ldap_search.first.gecos.first
        else
          'Es konnte kein eindeutiger Name gefunden werden.'
        end
      else
        'Keine Verbindung zum LDAP'
      end
    rescue Errno::ECONNREFUSED => e
      Rails.logger.error(e)
      'Keine Verbindung zum LDAP'
    rescue Exception => e
      Rails.logger.error(e)
      'Unbekannter LDAP Fehler'
    end
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
    rescue Exception => e
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

