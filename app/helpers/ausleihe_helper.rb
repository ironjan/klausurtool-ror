module AusleiheHelper

  def lenders_and_receivers
    ArchivedOldLendOut.lenders_and_receivers | OldLendOut.lenders_and_receivers
  end

  def deposits
    ["Studierendenausweis", "Semesterticket", "Führerschein", "10 €"]
  end
end
