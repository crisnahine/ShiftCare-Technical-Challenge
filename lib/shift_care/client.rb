module ShiftCare
  # Client model representing a client in the system
  class Client
    attr_reader :id, :full_name, :email

    # Initialize a new Client
    # @param id [String, Integer] The client's unique identifier
    # @param full_name [String] The client's full full_name
    # @param email [String] The client's email address
    # @param data [Hash] Additional client data
    def initialize(id:, full_name:, email:, **data)
      @id = id
      @full_name = full_name
      @email = email.to_s.downcase # Normalize email for comparison
      @data = data # Store any additional data
    end

    # Returns all data as a hash
    # @return [Hash] All client data
    def to_h
      {
        id: @id,
        full_name: @full_name,
        email: @email
      }.merge(@data)
    end

    # Matches full_name against the provided query string (case insensitive)
    # @param query [String] The search query
    # @return [Boolean] True if full_name matches query
    def name_matches?(query)
      @full_name.to_s.downcase.include?(query.to_s.downcase)
    end

    # String representation of client
    # @return [String] Client full_name and email
    def to_s
      "#{@full_name} <#{@email}>"
    end
  end
end