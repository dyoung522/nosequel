require 'sequel'
require 'ostruct'

module Cinch
  module Extensions
    module Storage

      config = defined?(bot.config.storage) ? bot.config.storage : OpenStruct.new( StorageConfig.default_config )

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

      class StorageContainer

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

        def []=(key, value)
          if exists?(key) # column already exists
            data(key).update(value: value)
          else
            @data.insert(key: key.to_s, value: value)
          end
        end

        # TODO: Need to figure out how to chain these methods, so that data[:key].delete will work as expected
        def [](key)
          exists?(key) ? data(key).get(:value) : nil
        end

        def delete(key)
          data(key).delete if exists?(key)
        end
        alias_method :remove, :delete

        def exists?(key)
          data(key).count == 1 ? true : false
        end
        alias_method :exist?, :exists?

        def keys
          @data.to_hash(:key).keys
        end

        def values
          @data.to_hash(:value).keys
        end

        private

          def data(key)
            @data.where(key: key.to_s)
          end

      end

      def self.register( table )
        StorageContainer.new(table)
      end

      def self.drop!( table )
        DB.drop_table( table.to_sym ) if exists?(table)
      end

      def self.exists?( table )
        DB.table_exists?( table.to_sym )
      end

    end
  end
end
