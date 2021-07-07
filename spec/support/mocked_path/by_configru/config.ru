require_relative '../base'

module Rackal
  module Internal
    module Test
      module MockedPath
        class Configru < Base
          def self.forced_call_stack
            indirection_to_force_inclusion
          end
        end
      end
    end
  end
end
