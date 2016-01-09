class OldFolderInstance < ActiveRecord::Base
  belongs_to :old_folder
  belongs_to :old_lend_out, inverse_of: :old_folder_instances
  has_and_belongs_to_many :archived_old_lend_outs

  validates :number,        presence: true, :inclusion => {:in => 1..9}
  validates :old_folder_id, presence: true
  validates :barcodeId,     presence: true, uniqueness: true

end
