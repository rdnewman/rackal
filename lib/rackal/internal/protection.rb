module Rackal
  module Internal
    module Protection
      def self.apply
        return false if Rackal.environment.unprotected?

        begin
          require 'refrigerator'
        rescue LoadError
          false
        else
          Refrigerator.freeze_core
          true
        end
      end
    end
  end
end
