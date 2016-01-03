class OldFolder < ActiveRecord::Base
	has_many :old_exams
	has_many :old_folder_instances, dependent: :destroy

	CONTENT_TYPES  = ["Klausurordner", "Klausurmappe", "Prüfungsprotokollordner", "Prüfungsprotokollmappe", "Übungsblätter", "Sonstiges"]
	enum color: [:black, :red, :blue, :green]
	AREAS  = ["ESS", "MMWW", "SWT", "MUA", "Grundst. Info", "Mathe", "Sonstiges"]

	validates :title, presence: true
	validates :contentType,  presence: true, :inclusion => { :in => CONTENT_TYPES }
	validates :color, presence: true
	validates :area,  presence: true, :inclusion => { :in => AREAS }


	def self.search(search)
		# Replacing spaces as wild-cards
		search = search.gsub(" ", "%")
		Rails.logger.debug("Searching for \"#{search}\"")
		# We want exact match for date but non-exact matches for other values
		where("title LIKE ?", "%#{search}%")
	end

	def display_color
		I18n.t("old_folder.color.#{status}", default: color.humanize)
	end

	def self.color_names_for_select
		names = []
		colors.keys.each do |color|
			display_name = I18n.t("old_folder.color.#{color}", default: color.humanize)
			names << [display_name, color]
		end
		names
	end

end
