require 'sequel'
require 'ostruct'

# This Module provides middleware between Sequel and Cinch, providing a
# a storage method which works much like a Hash, but stores data in a database
# behind the scenes.
module Cinch
  module Extensions
    module Storage

      config = defined?(bot.config.storage) ? bot.config.storage : OpenStruct.new( Config.default_config )

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
      DB = Sequel.connect( connect_string + config.db_name )

      # Creates and returns a storage container
      # Usage: store = Storage.register(:table_name)
      def self.register( table )
        Container.new(table)
      end

      # Permanently deletes table from the underlying database
      def self.drop!( table )
        DB.drop_table( table.to_sym ) if exists?(table)
      end

      # Tests if table exists in the database, returns true or false
      def self.exists?( table )
        DB.table_exists?( table.to_sym )
      end

      # Storage::Container class defines the methods to
      class Container

        # Create and/or retrieve a table from our database
        # and returns a storage container class.
        # called via Storage.register(:table)
        def initialize(table)

          unless DB.table_exists?(table.to_sym)
            DB.create_table table do
              primary_key :id
              String      :key
              String      :value
            end
            DB.add_index table, :key
            DB.add_index table, :value
          end

          @table = table
          @data  = DB[table]
        end

        # storage[:key] = value
        # Assigns the <value> to a given <:key>
        def []=(key, value)
          if exists?(key) # column already exists
            data(key).update(value: value)
          else
            @data.insert(key: key.to_s, value: value)
          end
        end

        # TODO: Need to figure out how to chain these methods, so that data[:key].delete will work as expected
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

        # Returns an array of all keys stored in the container
        def keys
          @data.to_hash(:key).keys
        end

        # Returns an array of all values stored in the container
        def values
          @data.to_hash(:value).keys
        end

        #def each(&block)
        #  yield @data.select(:key, :value).next
        #end

        private

          def data(key)
            @data.where(key: key.to_s)
          end

      end
    end
  end
end
