class OldFolder < ActiveRecord::Base
	has_many :old_exams
	has_many :old_folder_instances

	@types  = ["Klausurordner" "Klausurmappe" "Prüfungsprotokollordner" "Prüfungsprotokollmappe" "Übungsblätter" "Sonstiges"]
	@colors = ["schwarz" "rot" "blau" "grün"]
	@areas  = ["ESS" "MMWW" "SWT" "MUA" "Grundst. Info" "Mathe" "Sonstiges"]

	validates :type,  presence: true, :inclusion => { :in => @types }
	validates :color, presence: true, :inclusion => { :in => @colors }
	validates :area,  presence: true, :inclusion => { :in => @areas }

end
