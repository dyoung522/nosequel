module Cinch
  class Configuration
    class Storage < Configuration
      KnownOptions = [:connected]

      def self.default_config
        {
            :connected => nil
        }
      end
    end
  end
end
