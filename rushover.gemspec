# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rushover/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brendon Murphy"]
  gem.email         = ["xternal1+github@gmail.com"]
  gem.summary       = %q{A simple ruby Pushover client}
  gem.description   = gem.summary
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rushover"
  gem.require_paths = ["lib"]
  gem.version       = Rushover::VERSION

  gem.add_dependency "json"
  gem.add_dependency "rest-client"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "contest"
  gem.add_development_dependency "fakeweb"
end

