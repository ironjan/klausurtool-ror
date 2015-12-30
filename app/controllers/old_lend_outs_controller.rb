class OldLendOutsController < ApplicationController
	layout "ausleihe", except: "error"
	
	def index
		@old_lend_outs = OldLendOut.all
	end

	def new
		@old_lend_out = OldLendOut.new
		@currently_lent_outs = OldLendOut.where(:receivingTime => nil)
	end


	def create
		@old_lend_out = OldLendOut.new(old_lend_out_params)

		old_folder_instances = folderList2oldFolderInstances
		mixed_content = hasMixedContent?(old_folder_instances)

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

	def hasMixedContent?(old_folder_instances)
		lend_outs = old_folder_instances.map { |i| i.old_lend_out }
		lent = lend_outs.reject { |l| l.nil? }
		mixed_content = (lent.count != lend_outs.count)
	end

	def folderList2oldFolderInstances
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
		old_folder_instances
	end

	def action
		old_folder_instances = folderList2oldFolderInstances
		mixed_content = hasMixedContent?(old_folder_instances)

		if mixed_content do
			# show error
		end

		if old_folder_instances.first().old_lend_out.nil?
			# check validity and lend
			else
		# check validity and return
		end
	end
	private
	def old_lend_out_params
		params.require(:old_lend_out).permit(:imt, :lender, :deposit, :student)
	end
end