module LocBox
  module Configs
    class PlatformConfig
      attr_accessor :name
      attr_accessor :version
      attr_accessor :box
      attr_accessor :box_url
      attr_accessor :box_download_insecure

      attr_accessor :platform_config_path
      attr_accessor :platform

      def self.from_env(args)
        args.each do |k, v|
          instance_variable_set("@#{k}", v) unless v.nil?
        end

        @platform = select_platform

        platform_config = new
        platform_config.name = \
          ENV.fetch(env_var('name'), @name)
        platform_config.version = \
          ENV.fetch(env_var('version'), @version)
        platform_config.box = \
          ENV.fetch(env_var('box'), @platform.fetch('box'))
        platform_config.box_url = \
          ENV.fetch(env_var('box_url'), @platform.fetch('box_url'))
        platform_config.box_download_insecure = \
          ENV.fetch(env_var('box_download_insecure'), \
            @platform.fetch('box_download_insecure'))
        platform_config
      end

      def self.env_var(var_name)
        var_name.to_s.upcase
      end

      def self.select_platform
        platforms = YAML.load_file(Pathname.new(@platform_config_path).realpath)
                        .fetch('platforms')

        platforms.fetch(@name).fetch(@version)
      end
    end
  end
end
