require_relative 'base_command'

module ShiftCare
  module Commands
    # Command to find duplicate clients by email
    class DuplicatesCommand < BaseCommand
      # Execute duplicates search
      # @param args [Array<String>] Command arguments (unused)
      # @return [Boolean] Success status
      def execute(args)
        duplicates = @repository.find_duplicates_by_email

        if duplicates.empty?
          puts "No duplicate emails found."
        else
          puts "Found #{duplicates.size} email(s) with duplicates:"

          duplicates.each_with_index do |(email, clients), index|
            puts "\n#{index + 1}. Email: #{email}"
            puts "   Clients:"
            clients.each do |client|
              puts "   - ID: #{client.id}, Name: #{client.full_name}"
            end
          end
        end

        true
      end

      # Help information for duplicates command
      # @return [String] Help text
      def help
        <<~HELP
          USAGE: duplicates
          
          Find clients with duplicate email addresses.
          
          Example:
            duplicates
        HELP
      end
    end
  end
end