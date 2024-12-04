# frozen_string_literal: true

require 'sqlite3'

# ConnectionManager
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
