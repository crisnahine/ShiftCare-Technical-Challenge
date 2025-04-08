module ShiftCare
  module Commands
    # Base abstract command class
    class BaseCommand
      # Initialize with repository
      # @param repository [ClientRepository] Client data repository
      def initialize(repository)
        @repository = repository
      end

      # Execute the command with arguments
      # @param args [Array<String>] Command arguments
      # @return [Boolean] Success status
      def execute(args)
        raise NotImplementedError, "#{self.class} must implement #execute"
      end

      # Display help information
      # @return [String] Help text
      def help
        raise NotImplementedError, "#{self.class} must implement #help"
      end

      private

      # Validate required arguments
      # @param args [Array<String>] Arguments to validate
      # @param count [Integer] Required number of arguments
      # @return [Boolean] True if valid
      def validate_args(args, count)
        return true if args.size >= count
        puts "Error: Not enough arguments."
        puts help
        false
      end
    end
  end
end