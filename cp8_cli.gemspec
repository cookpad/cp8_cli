# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cp8_cli/version"

Gem::Specification.new do |spec|
  spec.name          = "cp8_cli"
  spec.version       = Cp8Cli::VERSION
  spec.authors       = ["Jens Balvig"]
  spec.email         = ["jens@balvig.com"]

  spec.summary       = %q{Cookpad Global CLI.}
  spec.description   = %q{Cookpad Global CLI.}
  spec.homepage      = "https://github.com/balvig/cp8_cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-line"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "multi_json"
  spec.add_development_dependency "webmock"

  spec.add_dependency "activesupport"
  spec.add_dependency "colored"
  spec.add_dependency "highline"
  spec.add_dependency "launchy"
  spec.add_dependency "octokit", "~> 4.21"
  spec.add_dependency "thor"
  spec.add_dependency "tty-prompt"
  spec.add_dependency "os"
end
