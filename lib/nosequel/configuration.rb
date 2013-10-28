require 'sequel'

# NoSequel::Configuration class
module NoSequel
  class Configuration
    attr_accessor :db_type , :db_name, :db_user, :db_host

    # NoSequel::Configuration constructor
    # @return
    #   A Configuration object which holds the user supplied config along with class defaults.
    def initialize( opts = {} )
      config = default_config.merge(opts)
      config.each do |key, value|
        self.send("#{key}=", value) if self.respond_to?(key)
      end
    end

    # Create and return an active Sequel object
    # @return
    #   A Sequel Object
    def sequel
      Sequel.connect( sequel_url )
    end

    private

    # Converts the object into a textual string that can be sent to sequel
    # @return
    #   A string representing the object in a sequel-connect string format
    def sequel_url

      return '' unless db_type

      # Start our connection string
      connect_string = db_type + '://'

      # Add user:password if supplied
      unless db_user.nil?
        connect_string += db_user

        # Add either a @ or / depending on if a host was provided too
        connect_string += db_host ? '@' : '/'

        # Add host:port if supplied
        connect_string += db_host + '/' if db_host
      end

      connect_string + db_name
    end

    # Reasonable defaults for the Object
    def default_config
      {
          db_type: 'sqlite',    # Any database connector supported by the Sequel gem
          db_name: 'data.db',   # The name of the database (or file) to use
          db_user: nil,         # The database user and optional password (user:password)
          db_host: 'localhost'  # The database host and options port (host:port)
      }
    end

  end
end
