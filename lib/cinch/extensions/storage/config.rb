module Cinch
  module Extensions
    module Storage
      class Config < Cinch::Configuration
        KnownOptions = %w( db_type db_name db_user db_pass db_host )

        def self.default_config
          {
            db_type: 'sqlite',    # Any database connector supported by the Sequel gem
            db_name: 'data.db',   # The name of the database (or file) to use
            db_user: nil,         # The database user and optional password (user:password)
            db_host: nil,         # The database host and options port (host:port)
          }
        end

        def self.foo
          'bar'
        end
      end
    end
  end
end
