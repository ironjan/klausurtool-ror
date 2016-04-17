require 'barby'
require 'barby/barcode/ean_8'
require 'barby/outputter/html_outputter'

module Internal
  module Admin
    # Controller to provide print actions.
    class PrintController < ApplicationController
      layout 'print'

      # Returns the cover for the given barcode.
      def cover
        barcode = params[:barcode]
        if barcode.nil?
          flash[:alert] = 'Kein Ordner-Exemplar angegeben.' and return
        end

        @old_folder_instance = OldFolderInstance.find_by(barcodeId: barcode)

        if @old_folder_instance.nil?
          flash[:alert] = "Ordner-Exemplar mit Barcode `#{barcode}` nicht gefunden."
          @old_folder_instance = OldFolderInstance.new
        end

        Rails.logger.warn(barcode)
        Rails.logger.warn("#{@old_folder_instance.inspect}")

        padded_barcode = @old_folder_instance.barcodeId.to_s.rjust(7, '0')
        Rails.logger.warn(padded_barcode)

        barcode = Barby::EAN8.new(padded_barcode)

        @barcode_for_html = Barby::HtmlOutputter.new(barcode)
        @barcode_as_string = barcode.to_s
      end
    end
  end
end
