class OldLendOut < ActiveRecord::Base
  has_many :old_folder_instances, inverse_of: :old_lend_out


  validates :imt,         presence: true
  validates :lender,      presence: true
  validates :lendingTime, presence: true
  validates :deposit,     presence: true
  validates :weigth,      presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate  :either_both_receiving_or_none
  def either_both_receiving_or_none
  	if (receiver.nil? and not receivingTime.nil?) || (not receiver.nil? and receivingTime.nil?)
  		errors.add(:base, "receiver and receivingTime must both be set or both be unset.")
  	end
  end
end
