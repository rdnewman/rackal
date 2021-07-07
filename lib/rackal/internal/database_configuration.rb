require_relative 'configuration_file'

module Rackal
  module Internal
    class DatabaseConfiguration
      include ConfigurationFile

      attr_reader :parameters

      class << self
        def parameters
          new.parameters
        end
      end

      def initialize
        @parameters = parse
      end

    private

      def parse
        requested_key = Rackal.environment.env.to_s
        used_key = requested_key

        result = read_configuration('database') do |content|
          content.fetch(requested_key) { |_| content.fetch(used_key = 'default') }
        end

        result[:configuration_key] = {
          requested: requested_key,
          used: used_key
        }

        result
      end
    end
  end
end
