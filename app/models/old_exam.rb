class OldExam < ActiveRecord::Base
	belongs_to :folder

	validates :folder_id, presence: true
	validates :date,      presence: true
	validates :title,     presence: true,  length: { minimum: 5 }
	validates :examiners, presence: true,  length: { minimum: 5 }
end
