# frozen_string_literal: true

##
# This class is responsible for managing the database schema, including
# creating tables for the moment.
#
# - Creates and manages the schema for the database.
# - Defines the structure of the `books` table in the database.
#
class SchemaManager
  def initialize(connection_manager)
    @connection_manager = connection_manager
  end

  def create_books_table
    @connection_manager.with_connection do |conn|
      conn.execute <<-SQL
          CREATE TABLE IF NOT EXISTS books (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            price INTEGER NOT NULL,
            image_url TEXT,
            rating INTEGER,
            stock INTEGER,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
          );
      SQL
    end
  end
end
