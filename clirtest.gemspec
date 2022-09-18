require_relative 'lib/clirtest/version'

Gem::Specification.new do |s|
  s.name          = "clirtest"
  s.version       = Clirtest::VERSION
  s.authors       = ["PhilippePerret"]
  s.email         = ["philippe.perret@yahoo.fr"]

  s.summary       = %q{Tester for command line application in ruby language}
  s.description   = %q{Facilities to test ruby applications in command line.}
  s.homepage      = "https://github.com/PhilippePerret/clirtest"
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-color'
  s.add_dependency 'clir'

  s.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = "https://github.com/PhilippePerret/clirtest"
  s.metadata["changelog_uri"] = "https://github.com/PhilippePerret/clirtest/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|features)/}) }
  end
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]
end
