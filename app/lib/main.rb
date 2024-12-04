# frozen_string_literal: true

require_relative './book_searcher'
require_relative './book_presenter'

# BookSearcher
class BookSearchCLI
  def initialize
    @searcher = BookSearcher.new('db/books.db')
  end

  def start
    BookPresenter.print_welcome

    loop do
      BookPresenter.print_search_prompt
      query = gets&.chomp&.strip

      break if query&.downcase == 'exit'
      next if query.nil? || query.empty?

      search_and_display(query)
    rescue Interrupt
      BookPresenter.print_interrupt_message
    end

    BookPresenter.print_goodbye
  end

  private

  def search_and_display(query)
    results = @searcher.search(query)
    BookPresenter.print_search_results(results, query)
  rescue SQLite3::Exception => e
    BookPresenter.print_error("Database error: #{e.message}")
  end
end

book_searcher = BookSearchCLI.new
book_searcher.start
