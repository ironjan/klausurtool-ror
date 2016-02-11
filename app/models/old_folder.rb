class OldFolder < ActiveRecord::Base
  has_many :old_exams
  has_many :old_folder_instances, dependent: :destroy

  CONTENT_TYPES = ['Klausurordner', 'Klausurmappe', 'Prüfungsprotokollordner', 'Prüfungsprotokollmappe', 'Übungsblätter', 'Sonstiges']
  enum color: [:black, :red, :blue, :green]
  AREAS = ['ESS', 'MMWW', 'SWT', 'MUA', 'Grundst. Info', 'Mathe', 'Sonstiges']

  validates :title, presence: true
  validates :contentType, presence: true, :inclusion => {:in => CONTENT_TYPES}
  validates :color, presence: true
  validates :area, presence: true, :inclusion => {:in => AREAS}


  def self.search(search)
    if search.nil? || search.empty?
      order('old_folders.title ASC')
    else
      # Replacing spaces as wild-cards
      search = "%#{search.gsub(' ', '%')}%"
      up_search = search.upcase

      Rails.logger.debug("Searching for \"#{search}\"")
      # We want exact match for date but non-exact matches for other values
      where('title LIKE ?'\
            ' OR title LIKE ?', 
            search, 
            up_search)
          .order('old_folders.title ASC')
    end
  end

  # todo: is this the correct place for this method?
  def display_color
    I18n.t("old_folder.color.#{color}", default: color.humanize)
  end

  # todo: is this the correct place for this method?
  def css_color
    case color.to_sym
      when :black
        css_color = '#000'
      when :red
        css_color = '#f00'
      when :blue
        css_color = '#00f'
      when :green
        css_color = '#0f0'
      else
        css_color = ''
    end
    Rails.logger.debug("#{color} -> #{css_color}")
    css_color
  end
end
