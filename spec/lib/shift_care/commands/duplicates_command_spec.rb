require 'spec_helper'

RSpec.describe ShiftCare::Commands::DuplicatesCommand do
  let(:repository) { ShiftCare::ClientRepository.new(test_clients_path) }
  subject(:command) { described_class.new(repository) }

  describe '#execute' do
    context 'when duplicates exist' do
      it 'shows duplicate emails' do
        expect { command.execute([]) }.to output(/Found .* email\(s\) with duplicates/).to_stdout
        expect { command.execute([]) }.to output(/john\.smith@example\.com/).to_stdout
        expect { command.execute([]) }.to output(/alice\.j@example\.com/).to_stdout
      end
    end

    context 'when no duplicates exist' do
      before do
        # Mock repository to return no duplicates
        allow(repository).to receive(:find_duplicates_by_email).and_return({})
      end

      it 'shows a message when no duplicates are found' do
        expect { command.execute([]) }.to output(/No duplicate emails found/).to_stdout
      end
    end
  end

  describe '#help' do
    it 'returns usage information' do
      expect(command.help).to include('USAGE: duplicates')
      expect(command.help).to include('Find clients with duplicate email addresses')
    end
  end
end