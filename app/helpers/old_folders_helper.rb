module OldFoldersHelper
  class View
    def self.color_names_for_select
      names = []
      OldFolder.colors.keys.each do |color|
        display_name = I18n.t("old_folder.color.#{color}", default: color.humanize)
        names << [display_name, color]
      end
      names
    end
  end
end
