require 'rackal/internal/application'
require 'rackal/internal/database_configuration'
require 'rackal/internal/rack_environment'
require 'rackal/internal/protection'

module Rackal
  # Retrieves current Rack environment with convenience methods
  #
  # @param [Hash] options
  # @option options [true, false] :reset If true, resets cache and ensure fresh retrieval (defaults to: false)
  # @return [Object] an object
  def self.environment(options = {})
    reload = options.delete(:reload) || false
    @environment = nil if reload

    @environment = Internal::RackEnvironment.new(options)
  end

  def self.database_parameters(options = {})
    reload = options.delete(:reload) || false
    @database_parameters = nil if reload

    @database_parameters ||= Internal::DatabaseConfiguration.parameters
  end

  def self.env(key, options = {})
    reload = options.delete(:reload) || false
    @env = nil if reload

    @env ||= {}

    @env[key] || (@env[key] = ENV.fetch(key.to_s, nil))
  end

  def self.application
    @application ||= Internal::Application.new
  end

  def self.protect!
    Internal::Protection.apply
  end

  def self.root
    @root ||= application.root
  end
end
