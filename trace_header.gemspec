
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "trace_header/version"

Gem::Specification.new do |spec|
  spec.name          = "trace_header"
  spec.version       = TraceHeader::VERSION
  spec.authors       = ["Misaki Shioi"]
  spec.email         = ["shioi.mm@gmail.com"]

  spec.summary       = %q{To inspect how the response headers would be changed by Rack middleware}
  spec.description   = %q{TraceHedaer is to inspect how the response headers would be changed by Rack middleware, and display them in your terminal.}
  spec.homepage      = "https://github.com/shioimm/trace_header"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport'

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
end
