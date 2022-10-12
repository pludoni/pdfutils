require 'open3'

module Pludoni::Pdfutils
  class ConvertDocumentToPdf
    def initialize(blob)
      @blob = FileWrapper.make(blob)
    end

    def run(&block)
      fname = File.basename(@blob.filename.to_s, File.extname(@blob.filename.to_s))
      @blob.open do |source|
        # convert image to pdf
        tf = Tempfile.new([fname, '.pdf'])
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

        FileWrapper.make(tf, filename: "#{fname}.pdf")
      end
    end
  end
end
