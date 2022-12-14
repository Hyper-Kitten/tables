require_relative "lib/hyper_kitten_tables/version"

Gem::Specification.new do |spec|
  spec.name        = "hyper-kitten-tables"
  spec.version     = HyperKittenTables::VERSION
  spec.authors     = ["Joshua Klina"]
  spec.email       = ["joshua.klina@gmail.com"]
  spec.homepage    = "https://github.com/Hyper-Kitten/tables"
  spec.summary     = "A gem for easily generating consistent markup for your tables."
  spec.description = "A gem for easily generating consistent markup for your tables."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end
  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "actionview", ">= 6.0.0"
  spec.add_dependency "activesupport", ">= 6.0.0"
  spec.add_dependency "tzinfo-data"

  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rails-dom-testing"
  spec.add_development_dependency "puma"
end
