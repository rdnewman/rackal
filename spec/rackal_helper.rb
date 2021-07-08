require 'spec_helper'

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start { add_filter 'spec/' }

Dir['lib/**/*.rb'].each { |file| require "./#{file}" }
