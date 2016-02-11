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
      wild_card_search = "%#{search.gsub(' ', '%')}%"
      up_search = wild_card_search.upcase

      joins(:old_folder)
          .where('date LIKE ? OR old_exams.title LIKE ? OR old_exams.examiners LIKE ? OR old_folders.title LIKE ? '\
                 ' OR old_exams.title LIKE ? OR old_exams.examiners LIKE ? OR old_folders.title LIKE ?',
                 "#{search}%", wild_card_search, wild_card_search, wild_card_search, 
                 up_search, up_search, up_search)
          .order('old_folders.title ASC')
    end
  end


  def self.existing_titles
    select(:title).uniq.map(&:title)
  end

  def self.existing_examiners
    select(:examiners).uniq.map(&:examiners)
  end


end

