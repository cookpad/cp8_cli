# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dolma/version'

Gem::Specification.new do |spec|
  spec.name          = "dolma"
  spec.version       = Dolma::VERSION
  spec.authors       = ["Jens Balvig"]
  spec.email         = ["jens@balvig.com"]

  spec.summary       = %q{GitHub/Trello flow gemified.}
  spec.description   = %q{GitHub/Trello flow gemified.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency 'multi_json'
  spec.add_development_dependency "pry"
  spec.add_development_dependency 'webmock'
  spec.add_dependency "colored"
  spec.add_dependency "highline"
  spec.add_dependency "hirb"
  spec.add_dependency "hirb-colors"
  spec.add_dependency "hirb-unicode"
  spec.add_dependency "launchy"
  spec.add_dependency "ruby-trello"
end
