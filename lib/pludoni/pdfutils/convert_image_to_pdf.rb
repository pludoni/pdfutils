require 'open3'

module Pludoni::Pdfutils
  class ConvertImageToPdf
    def initialize(blob)
      @blob = FileWrapper.make(blob)
    end

    def run(&block)
      fname = File.basename(@blob.filename.to_s, '.*')
      @blob.open do |source|
        # convert image to pdf
        tf = Tempfile.new([fname, '.pdf'])
        tf.binmode
        cli = "gs -dNOSAFER -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -o #{tf.path} viewjpeg.ps -c \\(#{source.path}\\) viewJPEG"

        stdout, stderr, status = Open3.capture3(cli)
        unless status.success?
          raise ConversionFailedError, "PDF convertion failed: Command: #{cli}\nStdout: #{stdout}\nStderr: #{stderr}"
        end

        FileWrapper.make(tf, filename: "#{fname}.pdf")
      end
    end
  end
end
