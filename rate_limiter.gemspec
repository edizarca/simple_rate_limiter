require_relative 'lib/rate_limiter/version'

Gem::Specification.new do |spec|
  spec.name          = "rate_limiter"
  spec.version       = RateLimiter::VERSION
  spec.authors       = ["Ediz Arca"]
  spec.email         = ["ediz.arca@gmail.com"]

  spec.summary       = %q{Rate limiter gem}
  spec.description   = %q{Rate limiter gem}
  spec.homepage      = "http://edizarca.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")




  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'redis', '~> 4.2.2'
end
