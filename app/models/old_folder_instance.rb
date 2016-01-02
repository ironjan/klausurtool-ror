class OldFolderInstance < ActiveRecord::Base
  belongs_to :old_folder
  belongs_to :old_lend_out, inverse_of: :old_folder_instances

  validates :number,        presence: true, :inclusion => {:in => 1..9}
  validates :old_folder_id, presence: true
  validates :barcodeId,     presence: true, uniqueness: true


	def self.search(search)
		# Replacing spaces as wild-cards
    search = search.gsub(" ", "%")
    Rails.logger.debug("Searching for \"#{search}\"")
    # We want exact match for date but non-exact matches for other values
		where("number = ?", "#{search}")
	end
end
