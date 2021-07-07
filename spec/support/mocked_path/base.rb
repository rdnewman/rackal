module Rackal
  module Internal
    module Test
      module MockedPath
        class Base
          # to properly fake the path in the call stack, the below method CANNOT be
          # inherited; add it directly into the subclass
          #
          #   def self.forced_call_stack
          #    indirection_to_force_inclusion
          #   end

          class << self
          private

            def indirection_to_force_inclusion
              # in RSpec, be sure to only mock the reception of #caller_locations "once"
              # this one needs to invoke the Kernel's version or else StackTooDeep is triggered
              caller_locations
            end
          end
        end
      end
    end
  end
end
