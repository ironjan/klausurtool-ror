class OldFolder < ActiveRecord::Base
  has_many :old_exams
  has_many :old_folder_instances, dependent: :destroy

  CONTENT_TYPES = ['Klausurordner', 'Klausurmappe', 'Prüfungsprotokollordner', 'Prüfungsprotokollmappe', 'Übungsblätter', 'Sonstiges']
  enum color: [:black, :red, :blue, :green]
  enum area: [:sonstiges, :ess, :mmww, :swt, :mua, :grundstudium, :mathe]

  validates :title, presence: true
  validates :contentType, presence: true, :inclusion => {:in => CONTENT_TYPES}
  validates :color, presence: true
  validates :area, presence: true


  def self.search(search)
    if search.nil? || search.empty?
      order('old_folders.title ASC')
    else
      # Replacing spaces as wild-cards
      search = "%#{search}%".gsub(' ', '%').gsub(/[äöüÄÖÜ]/, '%')

      Rails.logger.debug("Searching for \"#{search}\"")
      # We want exact match for date but non-exact matches for other values
      where('title LIKE ?', search)
          .order('old_folders.title ASC')
    end
  end

  # todo: is this the correct place for these methods?
  def display_color
    I18n.t("old_folder.colors.#{color}", default: color.humanize)
  end
  def display_area
    I18n.t("old_folder.areas.#{area}", default: area.humanize)
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

  def to_s
    "#{id} - #{title}"
  end
end
