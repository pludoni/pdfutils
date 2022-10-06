require 'open3'

module Pludoni::Pdfutils
  class ConvertDocumentToPdf
    def initialize(blob)
      @blob = FileWrapper.make(blob)
    end

    def run(&block)
      @blob.open do |source|
        # convert image to pdf
        tf = Tempfile.new(['convert', '.pdf'])
        tf.binmode

        command = ['soffice']
        command << '--headless'
        command << '--convert-to'
        command << 'pdf'
        command << '--outdir'
        command << File.dirname(source.path)
        command << source.path
        stdout, stderr, status = Open3.capture3(*command)
        unless status.success?
          raise ConversionFailedError, "PDF conversion failed: Command: #{cli}\nStdout: #{stdout}\nStderr: #{stderr}"
        end
        pdf_path = source.path.sub(/\.[a-z0-9]+$/i, '.pdf')
        unless File.exist?(pdf_path)
          raise ConversionFailedError, "PDF conversion failed: Command: #{cli}\nStdout: #{stdout}\nStderr: #{stderr}"
        end

        FileUtils.move(pdf_path, tf.path)

        tf.open

        FileWrapper.make(tf)
      end
    end
  end
end
