class OldFolder < ActiveRecord::Base
	has_many :old_exams
	has_many :old_folder_instances

	CONTENT_TYPES  = ["Klausurordner", "Klausurmappe", "Prüfungsprotokollordner", "Prüfungsprotokollmappe", "Übungsblätter", "Sonstiges"]
	COLORS = ["schwarz", "rot", "blau", "grün"]
	AREAS  = ["ESS", "MMWW", "SWT", "MUA", "Grundst. Info", "Mathe", "Sonstiges"]

	validates :title, presence: true
	validates :contentType,  presence: true, :inclusion => { :in => CONTENT_TYPES }
	validates :color, presence: true, :inclusion => { :in => COLORS }
	validates :area,  presence: true, :inclusion => { :in => AREAS }

end
