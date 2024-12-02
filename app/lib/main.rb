# frozen_string_literal: true

require_relative './book_searcher'

def row_printer(row)
  id, title, price, image_url, rating, stock = row
  puts "ID: #{id}"
  puts "Title: #{title}"
  puts "Price: #{price}"
  puts "Image: #{image_url}"
  puts "Rating: #{rating}"
  puts "Stock: #{stock}"
  puts '----------------------------------------------------------------------------------------------'
end

def start_cli
  puts 'Welcome to the Book Search CLI!'
  loop do
    print "Enter a book name to search for (or type 'exit' to quit): "
    query = gets.chomp.strip

    break if query.downcase == 'exit'

    searcher = BookSearcher.new('db/books.db')
    result = searcher.search(query)
    if result.empty?
      puts "No books found matching '#{query}'"
    else
      result.each do |row|
        row_printer(row)
      end
    end
  rescue Interrupt
    puts "\nSearch interruped. Returning to the search prompt..."
  end
  puts 'Goodbye!'
end

start_cli
