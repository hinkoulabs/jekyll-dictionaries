# frozen_string_literal: true

require_relative "lib/jekyll-dictionaries/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-dictionaries"
  spec.version = JekyllDictionaries::VERSION
  spec.authors = ["hinkoulabs"]
  spec.email = ["siarhei.hinkou@hinkoulabs.com"]

  spec.summary = "A Jekyll theme plugin to generate JSON dictionaries for language learning applications"
  spec.homepage = "https://github.com/hinkoulabs/jekyll-dictionaries"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.extra_rdoc_files = Dir["README.md", "History.markdown", "LICENSE.txt"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'minima', '~> 2.5'
end
