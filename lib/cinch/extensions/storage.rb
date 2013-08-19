require 'cinch'
require 'sequel'
require 'cinch/configuration/storage'

module Cinch
  module Extensions
    module Storage

      config = defined?(bot.config.storage) ? bot.config.storage : OpenStruct.new( Cinch::Configuration::Storage.default_config )

      # Start our connection string, built it via the config.storage variables
      connect_string = "#{config.type || 'sqlite'}://"

      # Add user:password if supplied
      if config.user
        connect_string += "#{config.user}"
        connect_string += ":#{config.pass}" if config.pass
      end

      # Add host:port if supplied
      connect_string += "@#{config.host}/" if config.host

      puts connect_string

      # Create the Sequel connection
      DB = Sequel.connect( connect_string + 'data.db' )

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
            @data.where(key: key.to_s).update(value: value)
          else
            @data.insert(key: key.to_s, value: value)
          end
        end

        def [](key)
          exists?(key) ? @data.where(key: key.to_s).get(:value) : nil
        end

        def exists?(key)
          @data.where(key: key.to_s).count == 1 ? true : false
        end
        alias_method :exist?, :exists?

      end

      def self.register( table )
        StorageContainer.new(table)
      end

      def self.drop!( table )
        DB.drop_table( table.to_sym ) if self.exists?(table)
      end

      def self.exists?( table )
        return DB.table_exists?( table.to_sym )
      end

    end
  end
end
