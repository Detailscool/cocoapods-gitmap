# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-gitmap/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-gitmap'
  spec.version       = CocoapodsGitmap::VERSION
  spec.authors       = ['李远晖']
  spec.email         = ['henryli@kugou.net']
  spec.description   = %q{A short description of cocoapods-gitmap.}
  spec.summary       = %q{A longer description of cocoapods-gitmap.}
  spec.homepage      = 'https://github.com/EXAMPLE/cocoapods-gitmap'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
