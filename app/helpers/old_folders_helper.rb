module OldFoldersHelper
  class View
    def self.color_names_for_select
      names = []
      OldFolder.colors.keys.each do |color|
        display_name = I18n.t("old_folder.colors.#{color}", default: color.humanize)
        names << [display_name, color]
      end
      names
    end

    def self.area_names_for_select
      names = []
      OldFolder.areas.keys.each do |area|
        display_name = I18n.t("old_folder.areas.#{area}", default: area.humanize)
        names << [display_name, area]
      end
      names
    end
  end
end
