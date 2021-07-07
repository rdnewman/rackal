require_relative '../base'

module Rackal
  module Internal
    module Test
      module MockedPath
        class Application < Base
          def self.forced_call_stack
            indirection_to_force_inclusion
          end
        end
        #   include Base
        #   # class << self
        #   #   def forced_call_stack
        #   #     indirection_to_force_inclusion
        #   #   end

        #   # private

        #   #   def indirection_to_force_inclusion
        #   #     caller_locations # this needs to invoke the original Kernel's version
        #   #   end
        #   # end
        # end
      end
    end
  end
end
