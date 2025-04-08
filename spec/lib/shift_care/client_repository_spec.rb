require 'spec_helper'

RSpec.describe ShiftCare::ClientRepository do
  subject(:repository) { described_class.new(test_clients_path) }

  describe '#initialize' do
    it 'loads data from the JSON file' do
      expect(repository.count).to be > 0
    end

    it 'raises an error with invalid JSON' do
      allow(File).to receive(:read).and_return('invalid json')
      expect { described_class.new(test_clients_path) }.to raise_error(/Error parsing JSON file/)
    end

    it 'handles file not found gracefully' do
      expect { described_class.new('nonexistent.json') }.not_to raise_error
      expect(described_class.new('nonexistent.json').count).to eq(0)
    end
  end

  describe '#search_by_name' do
    it 'finds clients by exact full_name' do
      results = repository.search_by_name('John Smith')
      expect(results).not_to be_empty
      expect(results.map(&:full_name)).to all(include('John Smith'))
    end

    it 'finds clients by partial full_name' do
      results = repository.search_by_name('Smith')
      expect(results).not_to be_empty
      expect(results.map(&:full_name)).to all(include('Smith'))
    end

    it 'is case insensitive' do
      results = repository.search_by_name('john')
      expect(results).not_to be_empty
      expect(results.map(&:full_name).join).to include('John')
    end

    it 'returns empty array when no matches' do
      results = repository.search_by_name('NonExistentName')
      expect(results).to be_empty
    end

    it 'handles empty search query' do
      results = repository.search_by_name('')
      expect(results).to be_empty
    end

    it 'handles nil search query' do
      results = repository.search_by_name(nil)
      expect(results).to be_empty
    end
  end

  describe '#find_duplicates_by_email' do
    it 'finds clients with duplicate emails' do
      duplicates = repository.find_duplicates_by_email
      expect(duplicates).not_to be_empty

      # Test specific duplicate email cases
      expect(duplicates).to have_key('john.smith@example.com')
      expect(duplicates).to have_key('alice.j@example.com')

      # Check that each entry has at least 2 clients
      duplicates.each do |_email, clients|
        expect(clients.size).to be >= 2
      end
    end
  end

  describe '#all' do
    it 'returns all clients' do
      expect(repository.all).to all(be_a(ShiftCare::Client))
    end
  end

  describe '#count' do
    it 'returns the correct count' do
      expect(repository.count).to eq(repository.all.size)
    end
  end
end