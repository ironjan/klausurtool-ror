# An archived lend out. Used to create the lending archive.
class ArchivedOldLendOut < ActiveRecord::Base
  include LendersAndReceivers

  has_and_belongs_to_many :old_folder_instances

  validates :imt,           presence: true
  validates :lender,        presence: true
  validates :lendingTime,   presence: true
  validates :deposit,       presence: true
  validates :weigth,        presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :receiver,      presence: true
  validates :receivingTime, presence: true
end
