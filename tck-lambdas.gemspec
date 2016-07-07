# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tck/lambdas/version'

Gem::Specification.new do |spec|
  spec.name          = "tck-lambdas"
  spec.version       = Tck::Lambdas::VERSION
  spec.authors       = ["Fernando Garcia Samblas"]
  spec.email         = ["fernando.garcia@the-cocktail.com"]

  spec.summary       = %q{The Cocktail's AWS Lambda functions manager.}
  spec.homepage      = "https://github.com/the-cocktail/tck-lambdas"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://gems.the-cocktail.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  gem_files = File.join("lib", "**", "*.rb")
  template_files = File.join("lib", "tck", "templates", "*.erb")
  lambda_files = File.join("lib", "tck", "lambdas", "**", "*.*")

  spec.files = Dir[gem_files] +
               Dir[lambda_files] +
               Dir["exe/*"] +
               [
                 File.join("lib", "tck", "lambdas", "Rakefile"),
                 File.join("lib", "tck", "lambdas", "Gemfile"),
                 "README.md",
                 "LICENSE"
               ]

# `git ls-files -z` .split("\x0") #.reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
