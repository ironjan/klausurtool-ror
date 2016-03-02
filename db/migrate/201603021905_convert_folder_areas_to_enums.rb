class ConvertFolderAreasToEnums < ActiveRecord::Migration

  class OldFolder < ActiveRecord::Base
    AREAS = ['ESS', 'MMWW', 'SWT', 'MUA', 'Grundst. Info', 'Mathe', 'Sonstiges']
    enum area: [:sonstiges, :ess, :mmww, :swt, :mua, :grundstudium, :mathe]
  end


  def up
    rename_column :old_folders, :area, :area_name
    add_column :old_folders, :area, :integer, :default => 0, :null => false
    change_column :old_folders, :area, :integer, :null => true

    OldFolder.find_each do |o|
      case o.area_name
        when 'ESS'
          o.area = :ess
        when 'MMWW'
          o.area = :mmww
        when 'SWT'
          o.area = :swt
        when 'MUA'
          o.area = :mua
        when 'Grundst. Info'
          o.area = :grundstudium
        when 'Mathe'
          o.area = :mathe
        else
          o.area = :sonstiges
      end
      o.save!
    end
  end


  def down
    add_column :old_folders, :area_name, :string

    OldFolder.find_each do |o|
      case o.area
        when :black
          o.area_name = 'schwarz'
        when :red
          o.area_name = 'rot'
        when :blue
          o.area_name = 'blau'
        when :green
          o.area_name = 'grün'
        else
          o.area_name = 'schwarz'
      end
      o.save!
    end

    remove_column :old_folders, :area
    rename_column :old_folders, :area_name, :area
  end
end
