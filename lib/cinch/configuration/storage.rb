module Cinch
  class Configuration
    class Storage < Configuration
      KnownOptions = [:connected]

      def self.default_config
        {
          database: 'sqlite',
          user:     nil,
          password: nil
        }
      end
    end
  end
end
