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

  # Retrieves database connection parameters from configuration file
  # Requires `config/database.yml`.
  #
  # @param [Hash] options
  # @option options [true, false] :reset If true, resets cache and ensure fresh retrieval (defaults to: false)
  # @return [Hash]
  def self.database_parameters(options = {})
    reload = options.delete(:reload) || false
    @database_parameters = nil if reload

    @database_parameters ||= Internal::DatabaseConfiguration.parameters
  end

  # Retrieves OS environment values (`ENV`)
  #
  # @param [Hash] options
  # @option options [true, false] :reset If true, resets cache and ensure fresh retrieval (defaults to: false)
  # @return [String]
  def self.env(key, options = {})
    reload = options.delete(:reload) || false
    @env = nil if reload

    @env ||= {}

    @env[key] || (@env[key] = ENV.fetch(key.to_s, nil))
  end

  # Retrieves application details. Requires `config/rackal.yml`.
  #
  # @return [Object] an object
  def self.application
    @application ||= Internal::Application.new
  end

  # Applies Refrigerator gem (if available) in protected Rack environments
  #
  # @return [true, false] true if gem available and in protected environment; otherwise, false
  def self.protect!
    Internal::Protection.apply
  end

  # Returns root directory (inferred) for the application. Requires `config/rackal.yml`.
  #
  # @return [String] top (root) directory for the application
  def self.root
    @root ||= application.root
  end
end
