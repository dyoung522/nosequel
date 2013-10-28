# The idea is to add a NoSQL interface for the Sequel OR/M
#
# Author::    Donovan C. Young  (mailto:dyoung522@gmail.com)
# Copyright:: Copyright (c) 2013 Donovan C. Young
# License::   MIT
#
# :include:LICENSE.txt

require 'nosequel/version'
require 'nosequel/configuration'
require 'nosequel/container'

# Module methods
module NoSequel

  # Creates or Retrieves and returns a container object
  #
  # == Parameters:
  # === Required:
  # table::
  #   A string or symbol referencing the table name to use
  #
  # === Optional:
  # db_type::
  #   The database type (defaults to sqlite3)
  #
  # db_name::
  #   The database name (or file) to use
  #
  # db_user::
  #   The database user (along with optional :password, if necessary)
  #
  # db_host::
  #   The database host (defaults to localhost)
  #
  # == Returns:
  # A NoSequel::Container object
  #
  def self.register( table, config = {} )
    # Create the Sequel connection
    #Container.new(@sequel, table)
    @config = Configuration.new(config)
    @sequel = @config.sequel
    Container.new( @sequel, table )
  end

  # Permanently deletes table from the underlying database
  #
  def self.drop( table )
    raise RuntimeError, 'You must call register first' unless @sequel
    # Drop the table
    @sequel.drop_table( table.to_sym ) if exists?(table)
  end

  # Drops the database table and deletes the local file (if it exists)
  #
  def self.drop!( table )
    drop( table )

    # Remove the file (if any)
    File.unlink(@config.db_name) if File.exists?(@config.db_name)
  end

  # Tests if a table already exists in the database
  # == Returns:
  # true or false
  #
  def self.exists?( table )
    raise RuntimeError, 'You must call register first' unless @sequel
    @sequel.table_exists?( table.to_sym )
  end

end
