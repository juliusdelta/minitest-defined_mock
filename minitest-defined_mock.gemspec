# frozen_string_literal: true

require_relative "lib/minitest/defined_mock/version"

Gem::Specification.new do |spec|
  spec.name = "minitest-defined_mock"
  spec.version = Minitest::DefinedMock::VERSION
  spec.license = "MIT"

  spec.authors = ["JD"]
  spec.email = ["jd_gonzales@icloud.com"]

  spec.summary = "A safe way to use mocks when your object dependencies are intertwined"
  spec.description = <<~TEXT
    minitest-defined_mock ensures that any `Minitest::Mock`s you create maintain the contract
    that a test is expected. Ideally, dependencies are managed in a way where this isn't necessary,
    but sometimes we need tools like minitest-defined_mock to provide us a safety mechanism when
    the design itself is less safe.
  TEXT

  spec.homepage = "https://github.com/juliusdelta/minitest-defined_mock"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.6.0"

  spec.add_dependency "minitest", "~> 5.0"

  spec.add_development_dependency "standard", "~> 1.31.0"
end
