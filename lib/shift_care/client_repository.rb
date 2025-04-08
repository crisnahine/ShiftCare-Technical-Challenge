require 'json'
require_relative 'client'

module ShiftCare
  # Repository class for managing client data
  class ClientRepository
    # Initialize repository with data from JSON file
    # @param file_path [String] Path to JSON data file
    def initialize(file_path)
      @file_path = file_path
      @clients = []
      load_data if File.exist?(@file_path)
    end

    # Load client data from JSON file
    # @return [Array<Client>] Loaded clients
    def load_data
      data = JSON.parse(File.read(@file_path), symbolize_names: true)
      @clients = data.map do |client_data|
        Client.new(
          id: client_data[:id],
          full_name: client_data[:full_name],
          email: client_data[:email],
          **client_data.except(:id, :full_name, :email)
        )
      end
    rescue JSON::ParserError => e
      raise "Error parsing JSON file: #{e.message}"
    rescue => e
      raise "Error loading client data: #{e.message}"
    end

    # Find clients by partial full_name match
    # @param query [String] Search query
    # @return [Array<Client>] Matching clients
    def search_by_name(query)
      return [] if query.nil? || query.strip.empty? # Return empty array for nil or empty query
      @clients.select { |client| client.name_matches?(query) }
    end

    # Find duplicate clients by email
    # @return [Hash] Hash of duplicate emails with arrays of matching clients
    def find_duplicates_by_email
      @clients
        .group_by { |client| client.email }
        .select { |_email, clients| clients.size > 1 }
    end

    # Get all clients
    # @return [Array<Client>] All clients
    def all
      @clients
    end

    # Count of all clients
    # @return [Integer] Number of clients
    def count
      @clients.size
    end
  end
end