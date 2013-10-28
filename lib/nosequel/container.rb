require 'yaml'

# NoSequel::Container class
module NoSequel
  class Container

    # NoSequel::Container constructor ( called via NoSequel.register )
    # @param db [Sequel object]
    # @param table [Symbol] The objects key identifier
    # @return [Container object]
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

      @sequel = db
      @db     = db[table]
    end

    # @!attribute [r] db
    #   @return NoSequel data object
    # @!attribute [r] sequel
    #   @return Underlying Sequel database object
    attr_reader :db, :sequel

    # Assigns the <value> to a given <:key>
    def []=(key, value)
      obj = value.is_a?(String) ? value : YAML::dump(value)
      if exists?(key) # column already exists
        data(key).update(value: obj)
      else
        db.insert(key: key.to_s, value: obj)
      end
    end

    # Returns the value stored in :key, or nil of the data wasn't found.
    def [](key)
      exists?(key) ? YAML::load(value(key)) : nil
    end

    # Deletes :key from the nosequel container
    def delete(key)
      if exists?(key)
        value = value(key)
        data(key).delete
      end
      value
    end
    alias_method :remove, :delete

    # Checks if a given key exists in the container
    def has_key?(key)
      data(validate_key(key)).count == 1 ? true : false
    end
    alias_method :exist?, :has_key?
    alias_method :exists?, :has_key?

    private

    # Handle all other Hash methods
    def method_missing(meth, *args, &block)
      db.to_hash(:key, :value).send(meth, *args, &block)
    end

    # Make sure we respond to all Hash methods
    def respond_to?(meth)
      db.to_hash(:key, :value).respond_to?(meth)
    end

    # Returns a single record which matches key
    def data(key)
      db.where(key: validate_key(key).to_s)
    end

    # Returns the value of a given key
    def value(key)
      data(key).get(:value)
    end

    # Make sure the key is valid
    def validate_key(key)
      unless key.is_a?(Symbol) || key.is_a?(String)
        raise ArgumentError, 'Key must be a string or symbol'
      end
      key
    end

  end

end
