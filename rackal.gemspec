Gem::Specification.new do |s|
  s.name        = 'rackal'.freeze
  s.version     = '0.0.1'
  s.summary     = 'Rackal'.freeze
  s.description = <<~DESCRIPTION
    Rack application helpers
  DESCRIPTION

  s.licenses    = ['MIT'.freeze]

  s.authors     = ['Richard Newman'.freeze]
  s.email       = ['richard@newmanworks.com'.freeze]
  s.homepage    = 'https://rubygems.org/gems/rackal'.freeze

  s.required_ruby_version = '>= 2.6'
  s.rubygems_version = '2.6.1'.freeze

  s.files       = ['lib/rackal.rb'.freeze]
  s.require_paths = ['lib'.freeze]

  s.add_development_dependency 'rspec', '~> 3'
end
