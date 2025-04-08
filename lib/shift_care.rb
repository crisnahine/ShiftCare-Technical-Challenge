require_relative 'shift_care/cli'
require_relative 'shift_care/client'
require_relative 'shift_care/client_repository'
require_relative 'shift_care/commands/base_command'
require_relative 'shift_care/commands/search_command'
require_relative 'shift_care/commands/duplicates_command'

# Main ShiftCare module
module ShiftCare
  # Application version
  VERSION = '0.1.0'.freeze
end