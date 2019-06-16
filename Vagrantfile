# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

Dir[File.dirname(__FILE__) + '/src/lib/configs/*'].each do |file|
  require_relative file
end

Dir[File.dirname(__FILE__) + '/src/lib/utils/*'].each do |file|
  require_relative file
end

Vagrant.require_version ">= 2.0.0", "< 3.0.0"

begin
  VAGRANT_COMMANDS = ['box', 'connect', 'global-status', 'help', 'init', 'login', 'package', 'plugin', 'port', 'push', 'share', 'snapshot', 'version'].include? ARGV[0]

  MACHINE_COMMANDS = ['destroy', 'halt', 'powershell', 'provision', 'rdp', 'reload', 'resume', 'ssh', 'ssh-config', 'status', 'suspend', 'up', 'validate', 'vbguest'].include? ARGV[0]

  if MACHINE_COMMANDS

    machine_command = ARGV[0]
    machine_filter = ''

    for arg in ARGV
      if /\/[\w\d-]*\//.match?(arg)
        machine_filter = arg.tr('/', '')
      end
    end

    user_conf = LocBox::Configs::UserConfig.from_env

    machines = {}

    user_conf.machine_config_path.split(' ').each do |m|
      machines = machines.merge(YAML.load_file(Pathname.new(m).realpath))
    end

    puts
    puts
    puts '==> [LOCBOX] Active Definitions'
    puts '==>   Machine(s): ' + user_conf.machine_config_path
    puts '==>   Platform(s): ' + user_conf.platform_config_path
    puts
    puts
  end
end

Vagrant.configure(2) do |config|
  if MACHINE_COMMANDS
    machines.each do |m_name, m_type|
      next if !machine_filter.empty? && ! m_name.include?(machine_filter)

      puts "==> [LOCBOX] Executing command '#{machine_command}' for VM '#{m_name}'"

      mic = (m_type['mic'] || 1).to_i

      (1..mic).each do |i|
        machine_name = LocBox::Utils::Machine.get_name(m_name, mic, i)

        platform_conf = LocBox::Configs::PlatformConfig.from_env(
          platform_config_path: user_conf.platform_config_path,
          name: m_type.fetch('platform')['name'],
          version: m_type.fetch('platform')['version']
        )

        config.vm.define machine_name do |machine|
          machine.vm.hostname = machine_name

          machine.vm.box = platform_conf.box
          machine.vm.box_url = platform_conf.box_url
          machine.vm.box_download_insecure = platform_conf.box_download_insecure

          # Networking configuration
          if m_type.include?('networks')
            m_type.fetch('networks').each do |m_network|
              n_type = m_network.fetch('mode')
              n_opts = LocBox::Utils::Network.get_options(m_network, i)

              machine.vm.network(n_type, n_opts)
            end
          end

          # Synced Folders configuration
          if m_type.include?('synced_folders')
            m_type.fetch('synced_folders').each do |m_synced_folder|
              sf_host = m_synced_folder.fetch('host')
              sf_guest = m_synced_folder.fetch('guest')
              sf_opts = LocBox::Utils::SyncedFolder.get_options(m_synced_folder)

              machine.vm.synced_folder(sf_host, sf_guest, sf_opts)
            end
          end

          # Provider configuration
          if m_type.include?('provider')
            provider = m_type.fetch('provider')
            provider_type = provider.fetch('type')

            machine.vm.provider provider_type do |m_provider|
              m_provider.name = machine.vm.hostname

              if provider.include?('gui')
                m_provider.gui = true
              end

              if provider.include?('customizations')
                customizations = provider.fetch('customizations')
                customizations.each do |p_customization|
                  cust = \
                    LocBox::Utils::Provider.build_customization(:id, p_customization)

                  m_provider.customize cust unless \
                    p_customization.key?('filename') && \
                    Pathname.new(p_customization.fetch('filename')).exist?
                end
              end
            end
          end

          # Provisioner configuration
          if m_type.include?('provisioners')
            provisioners = m_type.fetch('provisioners')

            provisioners.each do |m_provisioner|
              provisioner_type = m_provisioner.fetch('type')

              machine.vm.provision provisioner_type do |instance|
                LocBox::Utils::Provisioner.get_options(instance, m_provisioner, @config)
              end
            end
          end
        end
      end
    end
  end
end
