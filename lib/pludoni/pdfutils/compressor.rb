require 'open3'

module Pludoni::Pdfutils
  class Compressor
    def initialize(blob)
      @blob = FileWrapper.make(blob)
    end

    def run
      fname = File.basename(@blob.filename.to_s, '.*')
      tf = Tempfile.new([fname, '.pdf'])
      tf.binmode
      input = @blob.to_tf
      cli = "gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=#{Shellwords.escape tf.path} #{Shellwords.escape input.path}"

      stdout, stderr, status = Open3.capture3(cli)
      unless status.success?
        raise CompressionFailed, "PDF Compression failed: \nStdout: #{stdout}\nStderr: #{stderr}"
      end

      FileWrapper.make(tf, filename: fname + ".pdf")
    end
  end
end
