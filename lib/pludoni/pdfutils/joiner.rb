require 'open3'

module Pludoni::Pdfutils
  class Joiner
    MAX_LENGTH = 200
    def initialize(blobs)
      @blobs = blobs.map { |i| FileWrapper.make(i) }
    end

    def run
      fname = @blobs.map(&:filename).map { |i| i.split('.').first[0..20] }.join('-')
      if fname.length > MAX_LENGTH
        fname = fname[0..MAX_LENGTH]
      end

      tf = Tempfile.new([fname, '.pdf'])
      tf.binmode
      tfs = @blobs.map { |i| i.to_tf }
      cli = "gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=#{tf.path} #{tfs.map(&:path).join(' ')}"
      stdout, stderr, status = Open3.capture3(cli)
      unless status.success?
        raise JoiningFailedError, "PDF Joining failed: \nStdout: #{stdout}\nStderr: #{stderr}"
      end

      FileWrapper.make(tf, filename: "#{fname}.pdf")
    end
  end
end
