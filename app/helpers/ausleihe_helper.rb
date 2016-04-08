module AusleiheHelper

  def lenders_and_receivers
    ArchivedOldLendOut.lenders_and_receivers | OldLendOut.lenders_and_receivers
  end

  def deposits
    ["Studierendenausweis", "Semesterticket", "Führerschein", "10 €"]
  end

  def color_class_for_lent_since(old_lend_out)

    time = old_lend_out.lendingTime
    t5 = 5.days.ago
    t2 = 2.days.ago
    Rails.logger.debug("#{time} - t2 #{t2}, t5 #{t5}")
    t_t5 = time < t5
    t_t2 = time < t2
    Rails.logger.debug("#{time} - t_t2 #{t_t2}, t_t5 #{t_t5}")
    if t_t5
      "red"
    elsif t_t2
      "orange"
    else
      ""
    end
  end

  def lent_since(old_lend_out)
    (Time.now - old_lend_out.lendingTime).to_i / 1.day
  end


  def self.string_to_barcode_id(s)
    if s.length == 4
      Rails.logger.debug(" `#{s}` is 4 chars long. barcode_id will be #{s}.")
      barcode_id = s
    elsif s.length == 8
      Rails.logger.debug(" `#{s}` is 8 chars long. barcode_id will be #{s[3..6]}.")
      barcode_id = s[3..6]
    else

      # Workaround for invalid barcodes taped on folders
      # remove leading zeros, then take the first four values (if existing)
      barcode_id = s.sub!(/^0*/, "")[0..3]
      Rails.logger.warn("Input `#{s}` for folderId or barcode was modified to `#{barcode_id}`.")
    end

    barcode_id
  end
end
