RSpec.describe Rackal::Internal::ConfigurationFile do
  subject(:test_client) { test_client_class.new }

  let(:test_client_class) do |example|
    Class.new do
      include example.example_group_instance.described_class

      def configuration_directory
        'spec/fixtures/config'
      end
    end
  end

  describe '#configuration_directory (in client that includes it)' do
    context 'when not overridden' do
      let(:standard_client) { standard_client_class.new }

      let(:standard_client_class) do |example|
        Class.new { include example.example_group_instance.described_class }
      end

      it 'assumes "config' do
        expect(standard_client.configuration_directory).to eq 'config'
      end
    end

    context 'when overridden' do
      let(:custom_client) { custom_client_class.new }
      let(:custom_client_class) do |example|
        Class.new do
          include example.example_group_instance.described_class

          def configuration_directory
            'notstandard'
          end
        end
      end

      it 'is customized' do
        expect(custom_client.configuration_directory).to eq 'notstandard'
      end
    end
  end

  describe '#read_configuration' do
    let(:retrieved_content) { test_client.read_configuration(filename) }
    let(:filename)          { 'database' }

    it 'reads the file' do
      expect(retrieved_content).to be_instance_of Hash
    end

    it 'assumes ".yml" extension' do
      expect { test_client.read_configuration('database.yml') }.to raise_error Errno::ENOENT
    end

    it 'raises ArgumentError if empty name given' do
      expect { test_client.read_configuration('') }.to raise_error ArgumentError
    end

    it 'raises ArgumentError if nil name given' do
      expect { test_client.read_configuration(nil) }.to raise_error ArgumentError
    end

    context 'with empty file' do
      let(:filename) { 'empty' }

      it 'returns nil' do
        expect(retrieved_content).to be_nil
      end
    end

    context 'when no block given' do
      it 'keys are symbols without having to transform' do
        expected_keys = [:default, :development, :staging, :production, :test]

        expect(retrieved_content.keys).to match_array expected_keys
      end

      it 'subkeys are strings (and not symbols)' do
        expected_keys = ['adapter', 'database', 'max_connections', 'password', 'username']

        expect(retrieved_content[:default].keys).to match_array expected_keys
      end
    end

    describe 'when block given' do
      it 'still ensures top-level keys are symbols' do
        custom_content = test_client.read_configuration(filename) do |content|
          content
        end
        expected_keys = [:default, :development, :staging, :production, :test]

        expect(custom_content.keys).to match_array expected_keys
      end

      it 'can modify the content' do
        custom_content = test_client.read_configuration(filename) do |content|
          content[:added_key] = 'test value'
          content
        end

        expect(custom_content.keys).to include :added_key
      end
    end
  end
end
