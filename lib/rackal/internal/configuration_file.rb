require_relative 'yaml_file'

module Rackal
  module Internal
    module ConfigurationFile
      include YamlFile

      def configuration_directory
        'config'
      end

      def read_configuration(yaml_filename)
        filename = yaml_filename&.strip || ''
        if filename.empty?
          raise ArgumentError, "must apply a YAML filename within #{configuration_directory}"
        end

        filepath = "#{configuration_directory}/#{yaml_filename}.yml"
        content = yaml_content(filepath)
        (block_given? ? yield(content) : content)&.transform_keys(&:to_sym)
      end
    end
  end
end
