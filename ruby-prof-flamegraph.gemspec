# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "ruby-prof-flamegraph"
  spec.version       = '0.3.0'
  spec.authors       = ["Thai Pangsakulyanont"]
  spec.email         = ["org.yi.dttvb@gmail.com"]
  spec.summary       = %q{ruby-prof printer that exports to fold stacks compatible with FlameGraph}
  spec.homepage      = "http://github.com/dtinth/ruby-prof-flamegraph"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", [">= 1.7", "< 3.0"]
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "ruby-prof", ">= 0.13", "< 2"
end
