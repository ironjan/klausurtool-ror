class ConvertOldFolderColorToEnum < ActiveRecord::Migration #:nodoc:


  def up
    rename_column :old_folders, :color, :color_name
    add_column :old_folders, :color, :integer, :default => 0, :null => false

    OldFolder.find_each do |o|
      case o.color_name
        when 'schwarz'
          o.color = :black
        when 'rot'
          o.color = :red
        when 'blau'
          o.color = :blue
        when 'grün'
          o.color = :green
        else
          o.color = :black
      end
      o.save!
    end

    remove_column :old_folders, :color_name
  end

  def down
    add_column :old_folders, :color_name, :string

    OldFolder.find_each do |o|
      case o.color
        when :black
          o.color_name = 'schwarz'
        when :red
          o.color_name = 'rot'
        when :blue
          o.color_name = 'blau'
        when :green
          o.color_name = 'grün'
        else
          o.color_name = 'schwarz'
      end
      o.save!
    end

    remove_column :old_folders, :color
    rename_column :old_folders, :color_name, :color
  end
end
