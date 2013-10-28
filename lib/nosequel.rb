# The idea is to add a NoSQL interface for the Sequel OR/M
#
# @author    Donovan C. Young  (mailto:dyoung522@gmail.com)
# Copyright Copyright (c) 2013 Donovan C. Young
# License   MIT
#
# :include:LICENSE.txt

require 'nosequel/version'
require 'nosequel/configuration'
require 'nosequel/container'

# Module methods
module NoSequel

  # Creates or Retrieves and returns a container object
  #
  # @param [Symbol, String] table
  #   A string or symbol referencing the table name to use
  #
  # @option config [String] :db_type (sqlite3) The database type
  # @option config [String] :db_name (data.db) The database name (or file) to use
  # @option config [String] :db_user The database user (along with optional :password, if necessary)
  # @option config [String] :db_host (localhost) The database host (defaults to localhost)
  # @return [NoSequel::Container]
  #
  def self.register( table, config = {} )
    # Create the Sequel connection
    #Container.new(@sequel, table)
    @config = Configuration.new(config)
    @sequel = @config.sequel
    Container.new( @sequel, table )
  end

  # Permanently deletes table from the underlying database
  # @param [Symbol, String] table
  def self.drop( table )
    raise RuntimeError, 'You must call register first' unless @sequel
    # Drop the table
    @sequel.drop_table( table.to_sym ) if exists?(table)
  end

  # Drops the database table and deletes the local file (if it exists)
  # @param [Symbol, String] table
  def self.drop!( table )
    drop( table )

    # Remove the file (if any)
    File.unlink(@config.db_name) if File.exists?(@config.db_name)
  end

  # Tests if a table already exists in the database
  # @param [Symbol, String] table
  # @return [Boolean]
  def self.exists?( table )
    raise RuntimeError, 'You must call register first' unless @sequel
    @sequel.table_exists?( table.to_sym )
  end

end
