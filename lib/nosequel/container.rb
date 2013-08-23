require 'sequel'
require 'ostruct'
require 'yaml'

# This Module provides key/value storage methods to a database powered by Sequel
# Once created, a nosequel container works much like a Hash, but stores the data
# in a database behind the scenes.
module NoSequel

  def initialize()
  end

  def self.make_config_string(opt_config)
    config = OpenStruct.new( NoSequel::Configuration.default_config.merge(opt_config.to_hash) )

    # Start our connection string
    connect_string = "#{config.db_type || 'sqlite'}://"

    # Add user:password if supplied
    if config.db_user
      connect_string += "#{config.db_user}"

      # Add either a @ or / depending on if a host was provided too
      connect_string += config.db_host ? '@' : '/'

      # Add host:port if supplied
      connect_string += "#{config.db_host}/" if config.db_host
    end

    connect_string + config.db_name
  end

  # Creates and returns a nosequel container
  def self.register( table, config = {} )
    # Create the Sequel connection
    @sequel = Sequel.connect( make_config_string(config) )
    Container.new(@sequel, table)
  end

  # Permanently deletes table from the underlying database
  def self.drop!( table )
    @sequel.drop_table( table.to_sym ) if exists?(table)
  end

  # Tests if table exists in the database, returns true or false
  def self.exists?( table )
    @sequel.table_exists?( table.to_sym )
  end

  # NoSequel::Container class defines the methods to
  class Container

    # Create and/or retrieve a table from our database
    # and returns a nosequel container class.
    # called via NoSequel.register(:table)
    def initialize(db, table)

      unless db.table_exists?(table.to_sym)
        db.create_table table do
          primary_key :id
          String      :key
          String      :value
        end
        db.add_index table, :key
        db.add_index table, :value
      end

      @db    = db[table]
      @table = table
    end

    attr_reader :table, :db

    # Assigns the <value> to a given <:key>
    def []=(key, value)
      obj = value.is_a?(String) ? value : YAML::dump(value)
      if exists?(key) # column already exists
        data(key).update(value: obj)
      else
        @db.insert(key: key.to_s, value: obj)
      end
    end

    # Returns the value stored in :key, or nil of the data wasn't found.
    def [](key)
      exists?(key) ? YAML::load(data(key).get(:value)) : nil
    end

    # Deletes :key from the nosequel container
    def delete(key)
      if exists?(key)
        value = data(key).get(:value)
        data(key).delete
      end
      value
    end
    alias_method :remove, :delete

    # Checks if a given key exists in the container
    def exists?(key)
      validate_key(key)
      data(key).count == 1 ? true : false
    end
    alias_method :exist?, :exists?

    # Handle all other Hash methods
    def method_missing(meth, *args, &block)
      @db.to_hash(:key, :value).send(meth, *args, &block)
    end

    # Make sure we respond to all Hash methods
    def respond_to?(meth)
      @db.to_hash(:key, :value).respond_to?(meth)
    end

    private

      # Returns a single record which matches key
      def data(key)
        validate_key(key)
        @db.where(key: key.to_s)
      end

      def validate_key(key)
        unless key.is_a?(Symbol) || key.is_a?(String)
          raise ArgumentError, 'Key must be a string or symbol'
        end
        true
      end

  end
end
