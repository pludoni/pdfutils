require 'open3'

module Pludoni::Pdfutils
  class Joiner
    def initialize(blobs)
      @blobs = blobs.map { |i| FileWrapper.make(i) }
    end

    def run
      tf = Tempfile.new(['joiner', '.pdf'])
      tf.binmode
      tfs = @blobs.map { |i| i.to_tf }
      cli = "gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=#{tf.path} #{tfs.map(&:path).join(' ')}"

        stdout, stderr, status = Open3.capture3(cli)
      unless status.success?
        raise JoiningFailedError, "PDF Joining failed: \nStdout: #{stdout}\nStderr: #{stderr}"
      end

      FileWrapper.make(tf)
    end
  end
end
