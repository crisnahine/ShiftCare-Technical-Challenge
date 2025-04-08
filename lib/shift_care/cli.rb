require_relative 'client_repository'
require_relative 'commands/search_command'
require_relative 'commands/duplicates_command'

module ShiftCare
  # Command Line Interface for the application
  class CLI
    # List of available commands
    COMMANDS = {
      'search' => Commands::SearchCommand,
      'duplicates' => Commands::DuplicatesCommand
    }.freeze

    # Initialize CLI with JSON data file path
    # @param file_path [String] Path to JSON data file
    def initialize(file_path)
      @repository = ClientRepository.new(file_path)
      @commands = {}

      # Initialize command instances
      COMMANDS.each do |full_name, command_class|
        @commands[full_name] = command_class.new(@repository)
      end
    rescue => e
      puts "Error initializing application: #{e.message}"
      exit(1)
    end

    # Run the CLI with the given arguments
    # @param args [Array<String>] Command line arguments
    # @return [Integer] Exit code
    def run(args)
      command_name = args.shift

      if command_name.nil? || command_name == 'help'
        show_help
        return 0
      end

      command = @commands[command_name]

      if command.nil?
        puts "Unknown command: #{command_name}"
        show_help
        return 1
      end

      result = command.execute(args)
      result ? 0 : 1
    end

    private

    # Display general help information
    def show_help
      puts "ShiftCare Client Manager"
      puts "\nAvailable commands:"

      @commands.each do |full_name, command|
        puts "\n#{full_name}"
        puts command.help.lines.map { |line| "  #{line}" }.join
      end
    end
  end
end