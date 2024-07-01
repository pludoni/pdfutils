
Gem::Specification.new do |spec|
  spec.name          = "pludoni_pdfutils"
  spec.version       = "0.5.0"
  spec.authors       = ["Stefan Wienert"]
  spec.email         = ["info@stefanwienert.de"]

  spec.summary       = %q{Convert to pdf, compress pdf, join pdf using Ghostscript}
  spec.description   = %q{Convert to pdf, compress pdf, join pdf using Ghostscript}
  spec.homepage      = "https://github.com/pludoni/pdfutils"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activestorage", ">= 5.2.0"
  spec.add_dependency "zeitwerk"
  spec.add_dependency "marcel"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
