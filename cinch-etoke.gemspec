
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cinch/plugins/etoke/version"

Gem::Specification.new do |spec|
  spec.name          = "cinch-etoke"
  spec.version       = Cinch::Plugins::Etoke::VERSION
  spec.authors       = ["Team Good Buds"]
  spec.email         = ["bill.gates@microsoft.com"]

  spec.summary       = %q{An implementation of the popular etoke script for Cinch bots}
  spec.description   = %q{Shout out to all my goony goons keeping it goony}
  spec.homepage      = "https://github.com/cinch-etoke/cinch-etoke"

  #spec.files         = `git ls-files -z`.split("\x0").reject do |f|
  #  f.match(%r{^(test|spec|features)/})
  #end
  spec.files = Dir['LICENSE', 'README.md', 'lib/**/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "cinch", "~> 2.3.4"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.7"
end
