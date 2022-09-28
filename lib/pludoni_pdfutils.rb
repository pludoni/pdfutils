require "zeitwerk"
require 'pludoni'

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.ignore("#{ __FILE__ }")
loader.setup

require 'pludoni/pdfutils'
