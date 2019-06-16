module LocBox
  module Configs
    class UserConfig
      attr_accessor :machine_config_path
      attr_accessor :platform_config_path

      def self.from_env
        user_config = new
        user_config.machine_config_path = \
          ENV.fetch(env_var('machine_config_path'), '/machines/default/MachineConfig.yml')
        user_config.platform_config_path = \
          ENV.fetch(env_var('platform_config_path'), '/platforms/default/PlatformConfig.yml')
        user_config
      end

      def self.env_var(var_name)
        var_name.to_s.upcase
      end
    end
  end
end
