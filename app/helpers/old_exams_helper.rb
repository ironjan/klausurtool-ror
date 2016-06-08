# Provides methods to find existing titles/examiners.
module OldExamsHelper

  def self.existing_titles
    OldExam.existing_titles
  end

  def self.existing_examiners
    OldExam.existing_examiners
  end

end
