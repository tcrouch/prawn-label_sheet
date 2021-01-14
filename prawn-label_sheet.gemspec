# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prawn/label_sheet/version'

Gem::Specification.new do |spec|
  spec.name          = 'prawn-label_sheet'
  spec.version       = Prawn::LabelSheet::VERSION
  spec.authors       = ['Tom Crouch']
  spec.email         = ['tom.crouch@gmail.com']

  spec.summary       = 'Generate PDF sets of labels & stickers.'
  spec.description   = <<~DESCRIPTION
    Generate sets of labels or stickers programmatically using Prawn PDF.
  DESCRIPTION
  spec.homepage      = 'https://github.com/tcrouch/prawn-label_sheet'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features|example)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = ">= 2.4.0"

  spec.add_dependency 'polyfill', '~> 1.1.0'
  spec.add_dependency 'prawn'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'relaxed-rubocop', '~> 2.4'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.8'
end
