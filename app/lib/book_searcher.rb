# frozen_string_literal: true

require_relative 'db/books_respository'
require_relative 'db/db_manager'

# This class handles searching for books in the database
class BookSearcher
  def initialize(db_name)
    @db = DBManager.new(db_name)
  end

  def search(book_name)
    @db.books.search_by_name(book_name)
  end
end
