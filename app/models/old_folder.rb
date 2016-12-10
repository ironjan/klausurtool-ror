# Models folders; note that folders correspond to phyiscal folder groups of the 
# same name. Physical folders relate to folder_instances.
class OldFolder < ActiveRecord::Base
  has_many :old_exams
  has_many :old_folder_instances, dependent: :destroy

  CONTENT_TYPES = ['Klausurordner', 'Klausurmappe', 'Prüfungsprotokollordner', 'Prüfungsprotokollmappe', 'Übungsblätter', 'Sonstiges']
  enum color: [:black, :red, :blue, :green, :white, :yellow]
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
      search = "%#{search}%".gsub(' ', '%')

      Rails.logger.debug("Searching for \"#{search}\"")
      # We want exact match for date but non-exact matches for other values
      where('title LIKE ?', search)
          .order('old_folders.title ASC')
    end
  end

  def folder_information
    "#{title} (#{contentType}, #{id})"
  end

  def contains_written_exams?
    contentType.in? ['Klausurordner', 'Klausurmappe']
  end

  # todo: is this the correct place for this method?
  def display_color
    I18n.t("old_folder.color.#{color}", default: color.humanize)
  end

  # todo: is this the correct place for this method?
  def css_color
    case color.to_sym
      when :black
        '#000'
      when :red
        '#f00'
      when :blue
        '#00f'
      when :green
        '#0f0'
      when :white 
        '#fff'
      when :yellow
        '#ff0'
      else
        ''
    end
  end

  def to_s
    "#{id} - #{title}"
  end
end
