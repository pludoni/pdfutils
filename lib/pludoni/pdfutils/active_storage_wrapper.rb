module Pludoni
  module Pdfutils
    class ActiveStorageWrapper < FileWrapper
      def filesize
        @file.byte_size
      end

      def to_tf
        file = Tempfile.new(["ActiveStorage-#{@file.id}-", @file.filename.extension_with_delimiter])
        ActiveStorage::Downloader.new(@file.service).send(:download, @file.key, file)
        file
      end

      def filename
        @file.filename.to_s
      end

      def open(&block)
        @file.open(&block)
      end

      def content_type
        @file.content_type
      end
    end
  end
end
