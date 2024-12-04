# frozen_string_literal: true

require_relative 'connection_manager'
require_relative 'schema_manager'
require_relative 'books_respository'
require_relative 'book'

##
# This class serves as the central manager for handling the database operations related
# to books. It orchestrates the interactions between the database connection, schema management,
# and the books repository.
#
# 1. Initialize the DBManager with the name of the database.
# 2. Use the `setup` method to set up the initial schema (e.g., create necessary tables).
# 3. Access the `books` repository to interact with book records in the database.
class DBManager
  attr_reader :books

  def initialize(db_name)
    @connection_manager = ConnectionManager.new(db_name)
    @schema_manager = SchemaManager.new(@connection_manager)
    @books = BooksRepository.new(@connection_manager)
  end

  def setup
    @schema_manager.create_books_table
  end
end
