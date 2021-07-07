require 'erb'
require 'yaml'

module Rackal
  module Internal
    module YamlFile
      def yaml_content(filepath)
        raise ArgumentError unless filepath.is_a?(String)

        YAML.safe_load(
          ERB.new(File.read(filepath)).result,
          aliases: true
        )
      end
    end
  end
end
