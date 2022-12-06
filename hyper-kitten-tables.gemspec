require_relative "lib/hyper_kitten_tables/version"

Gem::Specification.new do |spec|
  spec.name        = "hyper-kitten-tables"
  spec.version     = HyperKittenTables::VERSION
  spec.authors     = ["Joshua Klina"]
  spec.email       = ["joshua.klina@gmail.com"]
  spec.homepage    = "https://hyperkitten.org"
  spec.summary     = "A gem for easily generating consistent markup for your tables."
  spec.description = "A gem for easily generating consistent markup for your tables."
    spec.license     = "MIT"
  

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end
  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "actionview", ">= 7.0.4"
  spec.add_dependency "activesupport", ">= 7.0.4"
  spec.add_dependency "tzinfo-data"

  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rails-dom-testing"
  spec.add_development_dependency "puma"
end
