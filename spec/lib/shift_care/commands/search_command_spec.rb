require 'spec_helper'

RSpec.describe ShiftCare::Commands::SearchCommand do
  let(:repository) { ShiftCare::ClientRepository.new(test_clients_path) }
  subject(:command) { described_class.new(repository) }

  describe '#execute' do
    context 'with valid arguments' do
      it 'finds clients with matching names' do
        expect { command.execute(['Smith']) }.to output(/Found .* client\(s\) matching 'Smith'/).to_stdout
      end

      it 'shows a message when no clients are found' do
        expect { command.execute(['NonExistent']) }.to output(/No clients found matching 'NonExistent'/).to_stdout
      end
    end

    context 'with invalid arguments' do
      it 'returns false when no search query is provided' do
        expect(command.execute([])).to be false
      end

      it 'shows help when arguments are missing' do
        expect { command.execute([]) }.to output(/USAGE: search/).to_stdout
      end
    end
  end

  describe '#help' do
    it 'returns usage information' do
      expect(command.help).to include('USAGE: search')
      expect(command.help).to include('Search for clients by full_name')
    end
  end
end