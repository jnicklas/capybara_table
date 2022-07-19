# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capybara_table/version'

Gem::Specification.new do |spec|
  spec.name          = "capybara_table"
  spec.version       = CapybaraTable::VERSION
  spec.authors       = ["Jonas Nicklas"]
  spec.email         = ["jonas.nicklas@gmail.com"]

  spec.summary       = %q{Selectors for working with tables for Capybara}
  spec.homepage      = "https://www.github.com/jnicklas/capybara_table"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "capybara", ">= 3.31"
  spec.add_dependency "xpath", ">= 2.1"
  spec.add_dependency "terminal-table"
end
