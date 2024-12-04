# frozen_string_literal: true

# BookPresenter
class BookPresenter
  def self.print_welcome
    puts 'Welcome to the Book Search CLI!'
  end

  def self.print_goodbye
    puts 'Goodbye!'
  end

  def self.print_search_prompt
    print "\nEnter a book name to search for (or type 'exit' to quit): "
  end

  def self.print_book_details(row)
    id, title, price, image_url, rating, stock = row.values
    puts <<~DETAILS
      ID: #{id}
      Title: #{title}
      Price: £#{price}
      Image: #{image_url}
      Rating: #{rating}/5
      In Stock: #{stock == 1}
      #{'-' * 90}
    DETAILS
  end

  def self.print_search_results(results, query)
    if results.empty?
      puts "\nNo books found matching '#{query}'"
    else
      puts "\nFound #{results.length} book(s):"
      results.each { |row| print_book_details(row) }
    end
  end

  def self.print_error(message)
    puts "\nError: #{message}"
  end

  def self.print_interrupt_message
    puts "\nSearch interrupted. Returning to the search prompt..."
  end
end
