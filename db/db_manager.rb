# frozen_string_literal: true

require 'sqlite3'

# SQLite database manager
class DBManager
  attr_accessor :db

  def initialize(db_name)
    @db = SQLite3::Database.new(db_name)
    @cache = {}
  end

  def create_table
    @db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS books (
        id INTEGER PRIMARY KEY,
        title TEXT,
        price INTEGER,
        image_url TEXT,
        rating TEXT,
        stock TEXT
      );
    SQL
  end

  def insert(books)
    books.each do |book|
      @db.execute(
        'INSERT INTO books (title, price, image_url, rating, stock) VALUES(?, ?, ?, ?, ?)',
        [book[:title], book[:price], book[:image_url], book[:rating], book[:stock]]
      )
    end
  rescue SQLite3::SQLException => e
    puts "SQLite error: #{e.message}"
  ensure
    @db.close
  end

  def search_by_name(book_name)
    query = 'SELECT * FROM books WHERE title LIKE ?'
    @db.execute(query, "%#{book_name}%")
  end

  def close
    @db.close
  end
end
