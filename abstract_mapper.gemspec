$:.push File.expand_path("../lib", __FILE__)
require "abstract_mapper/version"

Gem::Specification.new do |gem|

  gem.name        = "abstract_mapper"
  gem.version     = AbstractMapper::VERSION.dup
  gem.author      = "Andrew Kozin"
  gem.email       = "andrew.kozin@gmail.com"
  gem.homepage    = "https://github.com/nepalez/abstract_mapper"
  gem.summary     = "AST for ruby mappers"
  gem.description = "The abstract syntax tree for ruby mappers"
  gem.license     = "MIT"

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = Dir["spec/**/*.rb"]
  gem.extra_rdoc_files = Dir["README.md", "LICENSE"]
  gem.require_paths    = ["lib"]

  gem.required_ruby_version = ">= 2.1"

  gem.add_runtime_dependency "transproc", "~> 0.2", "> 0.2.3"
  gem.add_runtime_dependency "ice_nine", "~> 0.11"

  gem.add_development_dependency "hexx-rspec", "~> 0.5"

end # Gem::Specification
