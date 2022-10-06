require 'mimemagic'

module Pludoni
  module Pdfutils
    class Error < StandardError; end
    class JoiningFailedError < Error; end
    class ConversionFailedError < Error; end
    class CompressionFailed < Error; end

    module_function

    # compresses the given file if larger than given max_size
    # @param file [File, Tempfile, ActiveStorage::Blob]
    # @param max_size [Integer] in bytes
    # @return [File, Tempfile]
    def compress_if_large(file, max_size:)
      file = FileWrapper.make(file)
      if max_size && file.filesize > max_size
        yield(file) if block_given?
        Compressor.new(file).run
      else
        file
      end
    end

    # converts all images to pdf and joins them if there are more than max_files
    # @param blobs [Array<ActiveStorage::Blob>]
    # @param max_files [Integer] keep max_files - 1 files, and join the rest
    # @param max_size [Integer] in bytes Convert individual file if larger than max_size
    def convert_all_to_pdf_and_join_max_size(blobs, max_files:, max_size: nil, &block)
      files = blobs.map { |upload| convert_to_pdf(upload, &block) }
      if files.length > max_files
        if block_given?
          yield("More than #{max_files}; joining, keeping first #{max_files - 1} files; joining the rest")
        end
        keep = files.take(max_files - 1)
        join = Joiner.new(files.drop(max_files - 1)).run(&block)
        files = keep + [join]
      end
      files.map do |file|
        compress_if_large(file, max_size: max_size) do
          yield("Compressing file") if block_given?
        end
      end
    end

    def convert_to_pdf(blob, &block)
      blob = FileWrapper.make(blob)
      case blob.content_type.to_s
      when /image/
        block.call("converting #{blob.filename.to_s} to pdf") if block_given?
        ConvertImageToPdf.new(blob).run(&block)
      when "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "application/msword",
        "application/vnd.ms-powerpoint",
        "application/vnd.oasis.opendocument.text",
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        block.call("converting #{blob.filename.to_s} to pdf") if block_given?
        ConvertDocumentToPdf.new(blob).run(&block)
      else
        blob
      end
    end
  end
end
