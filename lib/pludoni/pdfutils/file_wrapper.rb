module Pludoni
  module Pdfutils
    class FileWrapper
      def initialize(file)
        @file = file
      end

      def self.make(blob_or_file)
        case blob_or_file
        when ActiveStorage::Blob
          ActiveStorageWrapper.new(blob_or_file)
        when File, Tempfile
          LocalFileWrapper.new(blob_or_file)
        when FileWrapper
          blob_or_file
        else
          raise NotImplementedError, blob_or_file.class
        end
      end

      def filesize
        raise NotImplementedError
      end

      def open(&block)
        raise NotImplementedError
      end

      def content_type
        raise NotImplementedError
      end
    end
  end
end


