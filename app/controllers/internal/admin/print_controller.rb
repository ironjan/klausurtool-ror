require 'barby'
require 'barby/barcode/ean_8'
require 'barby/outputter/html_outputter'

# Provides actions related to printing
module Internal
  module Admin
    # Controller to provide print actions.
    class PrintController < ApplicationController
      layout 'print'

      # Returns the cover for the given barcode.
      def cover
        barcode = params[:barcode]
        if barcode.nil? || barcode.empty?
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

      # Generates a table of contents from the given params[:old_folder_id]
      def toc
        id = params[:old_folder_id]
        if id.nil? || id.empty?
          flash[:alert] = 'Kein Ordner angegeben.' and return
        end

        @old_folder = OldFolder.find_by_id(id)

        if @old_folder.nil?
          flash[:alert] = "Ordner mit Id `#{id}` nicht gefunden."
          @old_folder = OldFolder.new
        end

        @unarchived_exams = @old_folder.old_exams.select { |e| e.unarchived? }

        number_of_filler_exams = 37 - @unarchived_exams.count
        if number_of_filler_exams < 0
          flash[:warning] = 'Es können nicht alle Prüfungen auf eine Seite gedruckt werden. Bitte einige Klausuren archivieren oder auslaugern.'
        end

        filler_exam = OldExam.new
        while number_of_filler_exams > 0
          @unarchived_exams << filler_exam
          number_of_filler_exams -= 1
        end
      end

    end
  end
end
