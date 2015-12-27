class OldLendOutsController < ApplicationController
	def index
		@old_lend_outs = OldLendOut.all
	end

	def new
		@old_lend_out = OldLendOut.new
	end


	def create
		@old_lend_out = OldLendOut.new(old_lend_out_params)

		folder_list = params[:folder_list].split(/\r?\n/)
		
		old_folder_instances = []

		folder_list.each do |f|
			next if f.empty?
			# FIXME map to short barcode if long
			old_folder_instance = OldFolderInstance.find_by(barcodeId: f)
			if old_folder_instance.nil?
				@old_lend_out.errors.add(:base, "Es gibt kein Ordner-Exemplar #{f}.")
				Rails.logger.debug("Added error for #{f}")
			else
				old_folder_instances << old_folder_instance
			end
		end

		unavailable_folders = old_folder_instances.reject { |f| f.old_lend_out.nil?  }
		unavailable_folders.each { |f| @old_lend_out.errors.add(:base, "#{f.barcodeId} is not available.")}
		all_available = unavailable_folders.empty?

		unless @old_lend_out.errors.empty?
			render 'new'
			return
		end

		# Add time
		@old_lend_out.lendingTime = Time.new
		
		# No errors, now we start lending
		OldLendOut.transaction do
			if @old_lend_out.save!
				old_folder_instances.each do |i|
					i.old_lend_out = @old_lend_out
					i.save!
					Rails.logger.debug("Saved #{i.inspect}")
				end
			end
		end

		render 'success'
	rescue Exception => ex
		@old_lend_out.errors.add(:base, "Exception prevented save: #{ex}")
		render 'new'
	end


	private
	def old_lend_out_params
		params.require(:old_lend_out).permit(:imt, :lender, :deposit, :student)
	end
end