# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'virus_scan_service/version'

Gem::Specification.new do |spec|
  spec.name          = "virus_scan_service"
  spec.version       = VirusScanService::VERSION
  spec.authors       = ["Tomas Valent"]
  spec.email         = ["equivalent@eq8.eu"]
  spec.summary       = %q{Servce gem for triggering Virus checks}
  spec.description   = 'Gem contains runner that will pull JSON request ' +
                       'with list of files to scan, and run antivirus check ' +
                       'on that file. After that runner will send JSON PUT ' +
                       'request with scan results'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
end
