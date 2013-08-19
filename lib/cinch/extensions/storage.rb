require 'sequel'

module Cinch
  module Extensions
    module Storage

      # Create the Sequel connection
      DB = Sequel.sqlite('data.db')

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
        DB.drop_table( table )
      end

    end
  end
end
