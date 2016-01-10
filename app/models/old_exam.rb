class OldExam < ActiveRecord::Base
	belongs_to :old_folder

	validates :old_folder_id, presence: true
	validates :date,      presence: true
	validates :title,     presence: true
	validates :examiners, presence: true


	def self.search(search)
		# Replacing spaces as wild-cards
		search = search.gsub(' ', '%')
		# We want exact match for date but non-exact matches for other values
		where('date = ? OR title LIKE ? OR examiners LIKE ?',
					"%#{search}%", "%#{search}%", "%#{search}%")
	end
end
