# frozen_string_literal: true

require 'rspec'
require_relative '../lib/scraper'

describe Scraper do
  let(:scraper) { Scraper.new }
  describe '.greetings' do
    it 'should display a hello' do
      expect(scraper.greetings).to eq('hello')
    end
  end
end
