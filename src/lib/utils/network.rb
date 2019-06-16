module LocBox
  module Utils
    class Network
      def self.get_options(network, i)
        options = {}
        network.each do |k, v|
          if k == 'ip' && i > 1
            options[k.to_sym] = increment_ip(v, i) unless v.nil?
          elsif (k == 'guest' || k == 'host') && i > 1
            options[k.to_sym] = v + (i - 1) unless v.nil?
          else
            options[k.to_sym] = v unless v.nil? || k == 'node'
          end
        end
        options
      end

      def self.increment_ip(base, increment)
        subnets = base.split('.')
        subnets.map! do |sn|
          if subnets.last == sn
            (sn.to_i + (increment - 1)).to_s
          else
            sn
          end
        end
        subnets.join('.')
      end
    end
  end
end
