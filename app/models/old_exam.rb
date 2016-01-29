class OldExam < ActiveRecord::Base
  belongs_to :old_folder

  validates :old_folder_id, presence: true
  validates :date, presence: true
  validates :title, presence: true
  validates :examiners, presence: true


  # FIXME Check for typos
  def self.search(search)
    if not (search.nil? || search.empty?)
      # Replacing spaces as wild-cards
      search = search.gsub(' ', '%')
      wildCardSearch = "%#{search}%"

      # We want exact match for date but non-exact matches for other values
      # where('date LIKE ? OR title LIKE ? OR examiners LIKE ?',
      # 			"#{search}%", "%#{search}%", "%#{search}%")

      joins(:old_folder)
          .where('date = ? OR old_exams.title LIKE ? OR old_exams.examiners LIKE ? OR old_folders.title LIKE ?',
                 "#{search} 00:00:00", wildCardSearch, wildCardSearch, wildCardSearch)
          .order('old_folders.title ASC')
      else
      joins(:old_folder)
          .order('old_folders.title ASC')
    end
    end
  end
