class OldFolderInstance < ActiveRecord::Base
  belongs_to :old_folder

  validates :number,        presence: true, :inclusion => {:in => 1..9}
  validates :old_folder_id, presence: true
  validates :barcodeId,     presence: true, uniqueness: true

end
