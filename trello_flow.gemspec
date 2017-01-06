# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "trello_flow/version"

Gem::Specification.new do |spec|
  spec.name          = "trello_flow"
  spec.version       = TrelloFlow::VERSION
  spec.authors       = ["Jens Balvig"]
  spec.email         = ["jens@balvig.com"]

  spec.summary       = %q{GitHub/Trello flow gemified.}
  spec.description   = %q{GitHub/Trello flow gemified.}
  spec.homepage      = "https://github.com/balvig/trello-flow"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-line"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"

  spec.add_dependency "colored"
  spec.add_dependency "highline"
  spec.add_dependency "hirb"
  spec.add_dependency "hirb-colors"
  spec.add_dependency "hirb-unicode"
  spec.add_dependency "launchy"
  spec.add_dependency "multi_json"
  spec.add_dependency "spyke"
end
