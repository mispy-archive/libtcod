# -*- encoding: utf-8 -*-
require File.expand_path('../lib/libtcod/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jaiden Mispy"]
  gem.email         = ["mispy@staff.draftable.com"]
  gem.description   = %q{Ruby bindings for the libtcod roguelike library}
  gem.summary       = %q{Ruby bindings for the libtcod roguelike library}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "libtcod"
  gem.require_paths = ["lib"]
  gem.version       = TCOD::VERSION

  gem.add_development_dependency 'minitest'

  gem.add_runtime_dependency 'ffi', '~> 1.9.3'
end
