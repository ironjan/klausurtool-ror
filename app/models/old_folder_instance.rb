class OldFolderInstance < ActiveRecord::Base
  belongs_to :old_folder
  belongs_to :old_lend_out, inverse_of: :old_folder_instances
  has_and_belongs_to_many :archived_old_lend_outs

  validates :number, presence: true, :inclusion => {:in => 1..9}
  validates :old_folder_id, presence: true
  validates :barcodeId, presence: true, uniqueness: true

  def update_and_get_barcodeId
    self.barcodeId = "#{format('%03d', self.old_folder_id)}#{self.number}"
  end

  def self.search(search)
    if search.nil? || search.empty?
      @old_folder_instances = joins(:old_folder)
                                  .all
                                  .order_by_name_and_barcode
    else
      wildcard_search = "%#{search}%".gsub(' ', '%')

      @old_folder_instances = joins(:old_folder)
                                  .where('old_folders.title LIKE ? OR barcodeId LIKE ?',
                                         wildcard_search, wildcard_search)
                                  .order_by_name_and_barcode
    end
  end

  private
  def self.order_by_name_and_barcode
    order('old_folders.title ASC, old_folder_instances.barcodeId ASC')
  end

end
