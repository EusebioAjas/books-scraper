# frozen_string_literal: true

##
# This class handles Create and Read operations related to books in the system.
#
# It allows for:
# - Insert books to the collection.
# - Retrieving books details by book title.
#
# Additionally, the class:
# - Implements very simple search cache to improve the efficiency of repeated search queries.
# - Validates input data when adding books.
class BooksRepository
  def initialize(connection_manager)
    @connection_manager = connection_manager
    @cache = {}
  end

  def insert(books)
    validate_books(books)

    @connection_manager.with_connection do |conn|
      conn.transaction do |tx|
        stmt = tx.prepare <<-SQL
          INSERT INTO books (title, price, image_url, rating, stock)
          VALUES (?, ?, ?, ?, ?)
        SQL

        books.each do |book|
          stmt.execute(
            book[:title],
            book[:price],
            book[:image_url],
            book[:rating],
            book[:stock]
          )
        end
        stmt.close
      end
    end
  end

  def search_by_name(book_name)
    return @cache[book_name] if @cache.key?(book_name)

    @connection_manager.with_connection do |conn|
      stmt = conn.prepare('SELECT * FROM books WHERE title LIKE ?')
      results = stmt.execute("%#{book_name}%").to_a
      stmt.close

      @cache[book_name] = results
      results
    end
  end

  private

  def validate_books(books)
    raise ArgumentError, 'Books must be an array' unless books.is_a?(Array)
    raise ArgumentError, 'Books array is empty' if books.empty?
  end
end
