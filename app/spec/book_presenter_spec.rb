# frozen_string_literal: true

require 'rspec'
require_relative '../lib/book_presenter'

RSpec.describe BookPresenter do
  describe '.print_welcome' do
    it 'prints a welcome message' do
      expect { BookPresenter.print_welcome }.to output("Welcome to the Book Search CLI!\n").to_stdout
    end
  end

  describe '.print_goodbye' do
    it 'prints a goodbye message' do
      expect { BookPresenter.print_goodbye }.to output("Goodbye!\n").to_stdout
    end
  end

  describe '.print_search_prompt' do
    it 'prints the search prompt' do
      expect do
        BookPresenter.print_search_prompt
      end.to output("\nEnter a book name to search for (or type 'exit' to quit): ").to_stdout
    end
  end

  describe '.print_book_details' do
    let(:row) { { id: 1, title: 'Black Flags: The Rise of ISIS', price: 40.87, image_url: 'https://example.com/black_flags.jpg', rating: 4, stock: 1 } }

    it 'prints the book details in the correct format' do
      expected_output = <<~DETAILS
        ID: 1
        Title: Black Flags: The Rise of ISIS
        Price: £40.87
        Image: https://example.com/black_flags.jpg
        Rating: 4/5
        In Stock: true
        #{'-' * 90}
      DETAILS

      expect { BookPresenter.print_book_details(row) }.to output(expected_output).to_stdout
    end
  end

  describe '.print_search_results' do
    context 'when there are no results' do
      let(:query) { 'Nonexistent Book' }

      it 'prints a message indicating no books found' do
        expect do
          BookPresenter.print_search_results([], query)
        end.to output("\nNo books found matching '#{query}'\n").to_stdout
      end
    end

    context 'when there are results' do
      let(:results) do
        [
          { id: 1, title: 'Black Flags: The Rise of ISIS', price: 40.87,
            image_url: 'https://example.com/black_flags.jpg', rating: 4, stock: 1 },
          { id: 2, title: 'Orange Is the New Black', price: 24.61, image_url: 'https://example.com/orange_is_new_black.jpg', rating: 4.8, stock: 1 }
        ]
      end
      let(:query) { 'book' }

      it 'prints the correct number of results and details of each book' do
        expected_output = <<~DETAILS
          \nFound #{results.length} book(s):
          ID: 1
          Title: Black Flags: The Rise of ISIS
          Price: £40.87
          Image: https://example.com/black_flags.jpg
          Rating: 4/5
          In Stock: true
          #{'-' * 90}
          ID: 2
          Title: Orange Is the New Black
          Price: £24.61
          Image: https://example.com/orange_is_new_black.jpg
          Rating: 4.8/5
          In Stock: true
          #{'-' * 90}
        DETAILS

        expect { BookPresenter.print_search_results(results, query) }.to output(expected_output).to_stdout
      end
    end
  end

  describe '.print_error' do
    it 'prints the error message' do
      expect { BookPresenter.print_error('An error occurred') }.to output("\nError: An error occurred\n").to_stdout
    end
  end

  describe '.print_interrupt_message' do
    it 'prints the interrupt message' do
      expect do
        BookPresenter.print_interrupt_message
      end.to output("\nSearch interrupted. Returning to the search prompt...\n").to_stdout
    end
  end
end
