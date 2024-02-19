# frozen_string_literal: true

require_relative "lib/activeforce/version"

Gem::Specification.new do |spec|
  spec.name = "activeforce"
  spec.version = Activeforce::VERSION
  spec.authors = ["IvanSchlagheck", "rstammer"]
  spec.email = ["ivansch05@gmail.com", "robin.stammer@trendence.com"]

  spec.summary = "Ruby wrapper to mimick parts of ActiveRecord query interface to obtain data conveniently (and human friendly 😅) from Salesforce RESTful API."
  spec.homepage = "https://github.com/trendence/activeforce"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/trendence/activeforce"
  spec.metadata["changelog_uri"] = "https://github.com/trendence/activeforce/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Development dependencies
  spec.add_development_dependency "rspec", "~> 3.2"

  # Gem dependencies
  spec.add_dependency "rake", "~> 13.0"
  spec.add_dependency "rspec", "~> 3.2"
  spec.add_dependency "standard", "~> 1.3"
  spec.add_dependency "restforce", "~> 7.3.0"
end
