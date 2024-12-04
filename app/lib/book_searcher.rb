# frozen_string_literal: true

require_relative 'db/books_respository'
require_relative 'db/db_manager'

##
# This class is responsible for searching books in the database.
# It acts as a bridge between the user and the database, providing functionality
# to search for books by their name using the `BooksRepository` from the `DBManager`.
class BookSearcher
  def initialize(db_name)
    @db = DBManager.new(db_name)
  end

  def search(book_name)
    @db.books.search_by_name(book_name)
  end
end
