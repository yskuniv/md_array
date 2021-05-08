lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "md_array/version"

Gem::Specification.new do |spec|
  spec.name          = "md_array"
  spec.version       = MdArray::VERSION
  spec.authors       = ["ysk_univ"]
  spec.email         = ["ysk.univ.1007@gmail.com"]

  spec.summary       = %q{multi-dimensional array}
  spec.description   = %q{multi-dimensional array}
  spec.homepage      = "https://github.com/yskuniv/md_array"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do  # rubocop:disable Layout/ExtraSpacing, Layout/SpaceAroundOperators
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "debase", "~> 0.2.4"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.13"
  spec.add_development_dependency "ruby-debug-ide", "~> 0.7"
  spec.add_development_dependency "solargraph", "~> 0.40"
end
