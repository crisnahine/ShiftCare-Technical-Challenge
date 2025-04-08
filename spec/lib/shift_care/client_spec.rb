require 'spec_helper'

RSpec.describe ShiftCare::CLI do
  subject(:cli) { described_class.new(test_clients_path) }

  describe '#initialize' do
    it 'initializes with the given file path' do
      expect { cli }.not_to raise_error
    end

    it 'handles initialization errors' do
      allow(ShiftCare::ClientRepository).to receive(:new).and_raise("Test error")
      expect { described_class.new('some_path.json') }.to raise_error(SystemExit)
    end
  end

  describe '#run' do
    context 'with valid commands' do
      it 'runs the search command' do
        expect_any_instance_of(ShiftCare::Commands::SearchCommand).to receive(:execute).with(['Smith']).and_return(true)
        expect(cli.run(['search', 'Smith'])).to eq(0)
      end

      it 'runs the duplicates command' do
        expect_any_instance_of(ShiftCare::Commands::DuplicatesCommand).to receive(:execute).with([]).and_return(true)
        expect(cli.run(['duplicates'])).to eq(0)
      end
    end

    context 'with help or no command' do
      it 'shows help with no arguments' do
        expect { cli.run([]) }.to output(/Available commands/).to_stdout
        expect(cli.run([])).to eq(0)
      end

      it 'shows help with help command' do
        expect { cli.run(['help']) }.to output(/Available commands/).to_stdout
        expect(cli.run(['help'])).to eq(0)
      end
    end

    context 'with invalid commands' do
      it 'shows an error for unknown commands' do
        expect { cli.run(['unknown']) }.to output(/Unknown command/).to_stdout
        expect(cli.run(['unknown'])).to eq(1)
      end

      it 'returns non-zero on command failure' do
        allow_any_instance_of(ShiftCare::Commands::SearchCommand).to receive(:execute).and_return(false)
        expect(cli.run(['search', 'query'])).to eq(1)
      end
    end
  end
end