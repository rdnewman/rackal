module Rackal
  module Internal
    class RackEnvironment
      attr_reader :env

      # @api private
      def initialize(options = {})
        @env = (ENV['RACK_ENV'] || 'development').to_sym

        protect_test = options&.fetch(:protect_test, false) || false
        @protect_test = protect_test ? true : false # force boolean
      end

      # @return Array list of environments recognized as supported by RackEnvironment
      def self.supported
        [:production, :staging, :test, :development]
      end

      supported.each do |supported_name|
        # @!macro [attach] supported_name
        #   @method $1?()
        #   @return Boolean true if current environment is $1
        define_method("#{supported_name}?") { env == supported_name }
      end

      # @return Boolean true if current environment is supported
      def supported?
        @supported ||= self.class.supported.include? env
      end

      # @return Boolean true if current environment is not supported
      def unsupported?
        !supported?
      end

      # @return Array list environments treated as protected (e.g., :production)
      def protected
        @protected ||= self.class.supported -
                       (@protect_test ? [:development] : [:development, :test])
      end

      # @return Boolean true if current environment is to be treated as protected
      def protected?
        @is_protected ||= protected.include? env
      end

      # @return Boolean true if current environment is not to be treated as protected
      def unprotected?
        @is_unprotected ||= !protected?
      end
    end
  end
end
