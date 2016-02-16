class OldExam < ActiveRecord::Base
  belongs_to :old_folder

  validates :old_folder_id, presence: true
  validates :date, presence: true
  validates :title, presence: true
  validates :examiners, presence: true

  def self.search(search)
    if search.nil? || search.empty?
      joins(:old_folder)
          .order('old_folders.title ASC')
    else
      wild_card_search = "%#{search}%".gsub(' ', '%').gsub(/[äöüÄÖÜ]/,'%')
      prefix_search = "#{search}%"
      
      joins(:old_folder)
          .where('date LIKE ? OR old_exams.title LIKE ? OR old_exams.examiners LIKE ? OR old_folders.title LIKE ? ',
                 prefix_search, wild_card_search, wild_card_search, wild_card_search)
          .order('old_folders.title ASC')
    end
  end


  def self.existing_titles
    order(:title)
        .map {|e| e.title }
        .uniq
  end

  def self.existing_examiners
    order(:examiners)
        .map {|e| e.examiners }
        .uniq
  end


end

