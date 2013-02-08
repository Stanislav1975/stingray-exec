# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stingray/exec/version'

Gem::Specification.new do |gem|
  gem.name          = "stingray-exec"
  gem.version       = Stingray::Exec::VERSION
  gem.authors       = ["Dan Buch"]
  gem.email         = ["d.buch@modcloth.com"]
  gem.description   = %q{Stingray Traffic Manager Control API Client}
  gem.summary       = %q{Talks to Riverbed Stingray Traffic Manager over its SOAP Control API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'savon', '~> 1.2'
  gem.add_runtime_dependency 'pry', '~> 0.9'
end
