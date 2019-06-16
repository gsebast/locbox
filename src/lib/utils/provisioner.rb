require 'json'

module LocBox
  module Utils
    class Provisioner
      def self.get_options(instance, provisioner_variables, config)
        provisioner_variables.each do |k, v|
          if "#{k}" == "json"
            instance.instance_variable_set("@#{k}", normalize(v)) unless v.nil?
          else
            instance.instance_variable_set("@#{k}", v) unless v.nil?
          end
        end
        instance
      end

      def self.normalize(obj)
        if obj.is_a?(Hash)
          obj.inject({}) { |h, (k, v)| normalize_hash(h, k, v); h }
        else
          obj
        end
      end

      def self.normalize_hash(hash, key, value)
        case key
        when "driver", "provisioner", "busser"
          hash[key] = if value.nil?
                        {}
                      elsif value.is_a?(String)
                        default_key = key == "busser" ? "version" : "name"
                        { default_key => value }
                      else
                        normalize(value)
                      end
        else
          hash[key] = normalize(value)
        end
      end
    end
  end
end
