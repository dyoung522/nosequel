module NoSequel
  class Configuration
    attr_accessor :db_type , :db_name, :db_user, :db_host

    def initialize( opts = {} )
      config = Configuration::default_config.merge(opts)
      config.each do |key, value|
        self.send("#{key}=", value) if self.respond_to?(key)
      end
    end

    def self.default_config
      {
          db_type: 'sqlite',    # Any database connector supported by the Sequel gem
          db_name: 'data.db',   # The name of the database (or file) to use
          db_user: nil,         # The database user and optional password (user:password)
          db_host: 'localhost'  # The database host and options port (host:port)
      }
    end

    def to_hash
      {
          db_type: self.db_type,
          db_name: self.db_name,
          db_user: self.db_user,
          db_host: self.db_host
      }
    end
  end
end
