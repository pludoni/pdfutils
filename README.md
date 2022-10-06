# Pludoni::Pdfutils

[![Gem Version](https://badge.fury.io/rb/pludoni_pdfutils.svg)](https://badge.fury.io/rb/pludoni_pdfutils)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pludoni-pdfutils'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pludoni-pdfutils

requires ghostscript installed.

Conversion of document formats (docx etc.) requires soffice installed

## Usage

All method take either ActiveStorage::Blob or File/Tempfile as argument and return a Tempfile/File

```ruby
# compresses the given file if larger than given max_size
# @returns [Pludoni::Pdfutils::FileWrapper]
Pludoni::Pdfutils.compress_if_large(file, max_size: 5.megabytes)

# converts all images to pdf (keep pdf) and joins them if there are more than max_files
# @param blobs [Array<ActiveStorage::Blob>]
# @param max_files [Integer] keep max_files - 1 files, and join the rest
# @param max_size [Integer] in bytes Convert individual file if larger than max_size
# @returns [Array<Pludoni::Pdfutils::FileWrapper>]
Pludoni::Pdfutils.convert_all_to_pdf_and_join_max_size(blobs, max_files: 3, max_size: 5.megabytes)
```

Individual classes:

```ruby
# jpg
tempfile = Pludoni::Pdfutils::ConvertImageToPdf.new(image_file).run
# docx etc.
tempfile = Pludoni::Pdfutils::ConvertDocumentToPdf.new(image_file).run


tempfile = Pludoni::Pdfutils::Joiner.new(job_application.uploads.map(&:blob)).run

# compresses with Ghostscript + /ebook Profile
tempfile = Pludoni::Pdfutils::Compressor.new(pdf_file).run
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
