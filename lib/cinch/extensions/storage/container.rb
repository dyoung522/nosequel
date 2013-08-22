require 'sequel'
require 'ostruct'

# This Module provides middleware between Sequel and Cinch, providing a
# a storage method which works much like a Hash, but stores data in a database
# behind the scenes.
module Cinch
  module Extensions
    module Storage

      # Creates and returns a storage container
      def self.register( table, opt_config = {} )

        config = defined?(bot.config.storage) ? bot.config.storage : OpenStruct.new( Config.default_config.merge(opt_config) )

        # Start our connection string, built it via the config.storage variables
        connect_string = "#{config.db_type || 'sqlite'}://"

        # Add user:password if supplied
        if config.db_user
          connect_string += "#{config.db_user}"

          # Add either a @ or / depending on if a host was provided too
          connect_string += config.db_host ? '@' : '/'
        end

        # Add host:port if supplied
        connect_string += "#{config.db_host}/" if config.db_host


        # Create the Sequel connection
        @db = Sequel.connect( connect_string + config.db_name )
        Container.new(@db, table)
      end

      # Permanently deletes table from the underlying database
      def self.drop!( table )
        @db.drop_table( table.to_sym ) if exists?(table)
      end

      # Tests if table exists in the database, returns true or false
      def self.exists?( table )
        @db.table_exists?( table.to_sym )
      end

      # Storage::Container class defines the methods to
      class Container

        # Create and/or retrieve a table from our database
        # and returns a storage container class.
        # called via Storage.register(:table)
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

        # storage[:key] = value
        # Assigns the <value> to a given <:key>
        def []=(key, value)
          if exists?(key) # column already exists
            data(key).update(value: value)
          else
            @db.insert(key: key.to_s, value: value)
          end
        end

        # storage[:key]
        # Returns the value stored in :key, or nil of the data wasn't found.
        def [](key)
          exists?(key) ? data(key).get(:value) : nil
        end

        # storage.delete(:key)
        # Deletes :key from the storage container
        def delete(key)
          data(key).delete if exists?(key)
        end
        alias_method :remove, :delete

        # Checks if a given key exists in the container
        def exists?(key)
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
            @db.where(key: key.to_s)
          end

      end
    end
  end
end
