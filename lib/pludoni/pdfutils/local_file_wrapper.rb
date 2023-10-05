require 'marcel'
module Pludoni
  module Pdfutils
    class LocalFileWrapper < FileWrapper
      attr_writer :filename

      def filesize
        @file.size
      end

      def filename
        @filename || @file.path.split("/").last
      end

      def to_tf
        @file.rewind
        @file
      end

      def open(&block)
        @file.open(&block)
      end

      def content_type
        Marcel::MimeType.for(@file)
      ensure
        @file.rewind
      end
    end
  end
end
