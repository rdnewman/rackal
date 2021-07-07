require_relative 'configuration_file'

module Rackal
  module Internal
    class Application
      include ConfigurationFile

      # TODO: -- drop this?!
      def self.root
        new.root
      end

      def initialize
        @config = parse
      end

      # only supports bare class names (not under a namespace)
      def main_class
        raise NameError unless name

        @main_class ||= Object.const_get(name)
      end

      # lightly inspired by Rails implementation in
      # railties/lib/rails/engine.rb#find_root_with_flag
      def root
        return @root if defined?(@root) && @root

        paths = potential_root_paths

        # 1) preference is to find "config.ru" if possible
        # 2) if not (1), try to find main app
        # 3) if not (1) or (2) look for nearest lib/ directory
        [:configru, :app, :lib].each do |key|
          info = paths.detect { |path| path[key] }
          @root = info&.fetch(:dirname, nil)
          return @root if @root
        end

        # give up if we can't find it
        @root = Dir.pwd
      end

    private

      def parse
        @parse = read_configuration('rackal') { |content| content.fetch('rackal') }
      end

      def name
        @config[:app_main]
      end

      # only works in linux style OS (assumes path delimiter "/")
      def potential_root_paths
        appname = main_class_rb_filename

        caller_locations.lazy.map { |location| assess_location(location, appname) }
        #   assess_location
        #   path = location.absolute_path || location.path
        #   dirname = File.dirname(path)

        #   {
        #     dirname: dirname,
        #     configru: File.directory?(dirname) && File.exist?("#{dirname}/config.ru"),
        #     app: appname && (File.directory?(dirname) && File.exist?("#{dirname}/#{appname}")),
        #     # configru: File.directory?(path) && File.exist?("#{path}/config.ru"),
        #     # app: appname && (File.directory?(path) && File.exist?("#{path}/#{appname}")),
        #     lib: dirname.match?(/.*\/lib\/\z/)
        #   }
        # end
      end

      def assess_location(location, appname)
        path = location.absolute_path || location.path
        dirname = File.dirname(path)

        {
          dirname: dirname,
          configru: File.directory?(dirname) && File.exist?("#{dirname}/config.ru"),
          app: appname && (File.directory?(dirname) && File.exist?("#{dirname}/#{appname}")),
          # configru: File.directory?(path) && File.exist?("#{path}/config.ru"),
          # app: appname && (File.directory?(path) && File.exist?("#{path}/#{appname}")),
          lib: dirname.match?(/.*\/lib\/\z/)
        }
      end

      def main_class_rb_filename
        return nil unless name

        # stolen from Rails ActiveSupport (but simpler)
        word = name.gsub(/([A-Z\d]+)(?=[A-Z][a-z])|([a-z\d])(?=[A-Z])/) do
          (Regexp.last_match(1) || Regexp.last_match(2)) << '_'
        end
        "#{word.tr('-', '_').downcase}.rb"
      end
    end
  end
end
