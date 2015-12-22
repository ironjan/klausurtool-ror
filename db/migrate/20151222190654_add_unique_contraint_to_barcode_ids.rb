class AddUniqueContraintToBarcodeIds < ActiveRecord::Migration
	def change
		add_index(:old_folder_instances, :barcodeId, :unique => true)
	end
end
