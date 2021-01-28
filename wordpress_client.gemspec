lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wordpress_client/version'

Gem::Specification.new do |spec|
  spec.name = "wordpress_client"
  spec.version = WordpressClient::VERSION
  spec.authors = ["Magnus Bergmark", "Rebecca Meritz", "Hans Maaherra"]
  spec.email = ["magnus.bergmark@gmail.com", "rebecca@meritz.com", "hans.maaherra@gmail.com"]
  spec.summary = "A simple client to the Wordpress API."
  spec.description = "A simple client to the Wordpress API."
  spec.homepage = ""
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", [">= 0.9", "< 2"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "webmock", "~> 3.3"
  spec.add_development_dependency "yard", "~> 0.9"
end
