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
      wild_card_search = "%#{search}%".gsub(' ', '%').gsub(/[äöüÄÖÜ]/, '%')
      prefix_search = "#{search}%"

      joins(:old_folder)
          .where('date LIKE ? OR old_exams.title LIKE ? OR old_exams.examiners LIKE ? OR old_folders.title LIKE ? ',
                 prefix_search, wild_card_search, wild_card_search, wild_card_search)
          .order('old_folders.title ASC')
    end
  end


  def self.existing_titles
    order(:title)
        .map { |e| e.title }
        .uniq
  end

  def self.existing_examiners
    order(:examiners)
        .map { |e| e.examiners }
        .uniq
  end

  def date
    date_attr = read_attribute(:date)
    unless date_attr.nil?
      return date_attr
    end

    if has_invalid_date?
      if date_before_type_cast.nil?
        nil
      else
        date_before_cast.sub('0000', '1970').gsub('-00', '-01')
      end
    else
      date_attr
    end
  end

  def date_before_cast
    read_attribute_before_type_cast('date')
  end

  def has_invalid_date?
    date_before_cast.nil? || date_before_cast.include?('0000') || date_before_cast.include?('-00')
  end

end

