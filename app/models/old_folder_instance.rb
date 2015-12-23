class OldFolderInstance < ActiveRecord::Base
  belongs_to :old_folder

  before_validation :set_barcodeId

  validates :number,        presence: true, :inclusion => {:in => 1..9}
  validates :old_folder_id, presence: true
  validates :barcodeId,     presence: true, uniqueness: true

  def set_barcodeId
	self.barcodeId = "#{format("%03d", self.old_folder_id)}#{self.number}"
	Rails.logger.debug("Fixed barcodeId to #{barcodeId} before_validation")

  end
end
