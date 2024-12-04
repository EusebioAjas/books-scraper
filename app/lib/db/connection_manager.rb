# frozen_string_literal: true

require 'sqlite3'

##
# This class is responsible for managing the connection to a SQLite database.
#
# It handles:
# - Establish a connection to the database upon initialization.
# - Reconnecting to the database if the connection is closed.
# - Providing a convenient method (`with_connection`) to perform database operations within a block.k:w
# - Raising custom error handling for database-related issues.
class ConnectionManager
  class DatabaseError < StandardError; end

  def initialize(db_name)
    @db_name = db_name
    connect
  rescue SQLite3::SQLException => e
    raise DatabaseError, "Failed to initialize database: #{e.message}"
  end

  def with_connection
    connect if @db.closed?
    yield @db
  rescue SQLite3::SQLException => e
    raise DatabaseError, "Database error: #{e.message}"
  end

  private

  def connect
    @db = SQLite3::Database.new(@db_name)
    @db.results_as_hash = true
  end
end
