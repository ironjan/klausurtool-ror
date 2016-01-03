module OldFoldersHelper
  class OldFoldersViewHelper
    def colors_map
      OldFolder.color.to_a.map { |o|
        case o
          when :black
            ["schwarz", o]
          when :red
            ["rot", o]
          when :blue
            ["blau", o]
          when :green
            ["grün", o]
          else
            ["Fehler: Farbe fehlt in old_folders_helper", o]
        end
      }
    end

  end
end
