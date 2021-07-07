require 'spec_helper'

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start { add_filter 'spec/' }

Dir.glob('lib/**/*.rb').sort.each { |file| require_relative "../#{file}" }
