module LocBox
  module Utils
    class Machine
      def self.get_name(name, mic, i)
        if mic == 0 || mic == 1 || i == 1 || mic.nil?
          name
        else
          name + '-' + i.to_s
        end
      end
    end
  end
end
