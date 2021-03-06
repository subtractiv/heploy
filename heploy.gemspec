# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heploy/version'

Gem::Specification.new do |gem|
  gem.name          = "heploy"
  gem.version       = Heploy::VERSION
  gem.authors       = ["Nathan Borgo"]
  gem.email         = ["nathan@subtractiv.com"]
  gem.description   = %q{Heploy deploys your application to Heroku, using a bunch of best practices and other nice things.}
  gem.summary       = %q{Deploy your application to Heroku, even easier.}
  gem.homepage      = ""

  gem.add_dependency "thor"
  gem.add_dependency "git"
  gem.add_dependency "heroku"
  gem.add_dependency "rake"
  gem.add_development_dependency "minitest"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
