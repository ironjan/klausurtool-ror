class OldExam < ActiveRecord::Base
	belongs_to :old_folder

	validates :old_folder_id, presence: true
	validates :date,      presence: true
	validates :title,     presence: true,  length: { minimum: 5 }
	validates :examiners, presence: true,  length: { minimum: 5 }
end
