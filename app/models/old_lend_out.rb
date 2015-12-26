class OldLendOut < ActiveRecord::Base
  has_many :old_folder_instances

  validates :student, presence: true
  validates :imt, presence: true
  validates :lender, presence: true
  validates :lendingTime, presence: true
  validates :deposit, presence: true

  validate :either_both_receiving_or_none

  def either_both_receiving_or_none
  	if (receiver.nil? and not receivingTime.nil?) || (not receiver.nil? and receivingTime.nil?)
  		errors.add(:base, "receiver and receivingTime must both be set or both be unset.")
  	end
  end
end
