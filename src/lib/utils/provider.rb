module LocBox
  module Utils
    class Provider
      def self.build_customization(id, inputs)
        options = []

        inputs.each do |k, v|
          if k == 'mod_command' && inputs.fetch('param') == 'uuid'
            options.push(v, id)
          elsif k == 'mod_command'
            options.push(v, inputs.fetch('param'))
          elsif k.include?('/') || k.include?('Video')
            options.push("#{k}", "#{v}") unless v.nil?
          else
            options.push("--#{k}", "#{v}") unless v.nil? || k == 'param'
          end
        end
        options
      end
    end
  end
end
