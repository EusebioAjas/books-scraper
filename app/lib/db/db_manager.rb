# frozen_string_literal: true

require_relative 'connection_manager'
require_relative 'schema_manager'
require_relative 'books_respository'
require_relative 'book'

# DB Manager
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
