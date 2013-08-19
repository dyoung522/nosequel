module Cinch
  class Configuration
    class Storage < Configuration
      KnownOptions = [:database, :host, :user, :password]

      def self.default_config
        {
          type: 'sqlite',
          user: nil,
          pass: nil,
          host: 'localhost'
        }
      end
    end
  end
end
