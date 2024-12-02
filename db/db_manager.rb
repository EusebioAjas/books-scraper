# frozen_string_literal: true

require 'sqlite3'

# SQLite database manager
class DBManager
  attr_accessor :db

  def initialize
    @db = SQLite3::Database.new 'db/books.db'
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

  private

  def row_printer(row)
    id, title, price, image_url, rating, stock = row
    puts "ID=#{id} title=#{title} price=#{price} image=#{image_url} rating=#{rating}} stock=#{stock}"
  end

  public

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

  def find_all
    results = @db.execute('SELECT * FROM books')

    results.each do |row|
      row_printer(row)
    end
  end

  def find(title)
    results = db.execute('SELECT * FROM books WHERE title = ?', [title])
    results.each do |row|
      row_printer(row)
    end
  end

  def close
    @db.close
  end
end
