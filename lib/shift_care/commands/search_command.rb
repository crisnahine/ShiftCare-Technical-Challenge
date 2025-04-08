require_relative 'base_command'

module ShiftCare
  module Commands
    # Command to search clients by full_name
    class SearchCommand < BaseCommand
      # Execute search
      # @param args [Array<String>] Command arguments (search query)
      # @return [Boolean] Success status
      def execute(args)
        return false unless validate_args(args, 1)

        query = args.first
        results = @repository.search_by_name(query)

        if results.empty?
          puts "No clients found matching '#{query}'"
        else
          puts "Found #{results.size} client(s) matching '#{query}':"
          results.each_with_index do |client, index|
            puts "#{index + 1}. #{client}"
          end
        end

        true
      end

      # Help information for search command
      # @return [String] Help text
      def help
        <<~HELP
          USAGE: search <full_name>
          
          Search for clients by full_name.
          The search is case-insensitive and matches partial names.
          
          Example:
            search Smith
        HELP
      end
    end
  end
end