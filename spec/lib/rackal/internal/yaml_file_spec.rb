RSpec.describe Rackal::Internal::YamlFile do
  subject(:content) { client.yaml_content(path) }

  let(:client) { client_class.new }
  let(:client_class) do |example|
    Class.new { include example.example_group_instance.described_class }
  end

  let(:path) { "spec/fixtures/config/#{filename}.yml" }

  context 'for rackal.yml' do
    let(:filename) { 'rackal' }

    let(:expected_content) do
      {
        'rackal' => {
          'app_main' => 'SomeApp'
        }
      }
    end

    it 'retrieves raw hash of expected content' do
      expect(content).to eq expected_content
    end
  end

  context 'for database.yml' do
    let(:filename) { 'database' }

    it 'has expected keys' do
      expected_keys = [:default, :development, :staging, :production, :test]

      retrieved_keys = content.transform_keys(&:to_sym).keys
      expect(retrieved_keys).to match_array expected_keys
    end

    it 'default key includes adapter value' do
      default = content['default']

      expect(default['adapter']).to eq 'postgres'
    end
  end

  context 'when file missing' do
    let(:filename) { 'does_not_exist' }

    it 'raises Errno::ENOENT exception' do
      expect { content }.to raise_error Errno::ENOENT
    end
  end

  context 'for invalid YAML content' do
    let(:filename) { 'invalid_yaml' }

    it 'raises exception from Psych' do
      expect { content }.to raise_error Psych::SyntaxError
    end
  end
end
