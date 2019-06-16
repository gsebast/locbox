module LocBox
  module Utils
    class SyncedFolder
      def self.get_options(folder)
        options = {}
        folder.each do |k, v|
          options[k.to_sym] = v unless v.nil? || k == 'host' || k == 'guest'
        end
        options
      end
    end
  end
end
