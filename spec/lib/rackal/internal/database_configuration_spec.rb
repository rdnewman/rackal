RSpec.describe Rackal::Internal::DatabaseConfiguration do
  # TODO: `allow_all_instances_of` is no longer preferred by RSpec, but difficult
  # to avoid here with more targeted techniques without resorting to, say, inheritance
  # to override behavior which seems worse

  subject(:config) { described_class.new }

  let(:params) { config.parameters }

  before do
    allow_any_instance_of(described_class)
      .to receive(:configuration_directory)
      .and_return('spec/fixtures/config')
  end

  shared_examples 'valid parameters' do
    it 'as a hash' do
      expect(params).to be_a Hash
    end

    it 'with an adapter' do
      expect(params.keys).to include :adapter
    end

    it 'with a database naame' do
      expect(params.keys).to include :database
    end

    it 'with a username' do
      expect(params.keys).to include :username
    end

    it 'with a password' do
      expect(params.keys).to include :password
    end

    it 'with recorded keys for the configuration' do
      expect(params.keys).to include :configuration_key
    end

    it 'with requested configuration key' do
      expect(params[:configuration_key].keys).to include :requested
    end

    it 'with the configuration key that was actually used' do
      expect(params[:configuration_key].keys).to include :used
    end

    it 'with a requested configuration key matching the environment' do
      expect(params[:configuration_key][:requested]).to eq Rackal.environment.env.to_s
    end
  end

  context 'for testing' do
    it_behaves_like 'valid parameters'

    it 'uses the test configuration' do
      expect(params[:configuration_key][:used]).to eq 'test'
    end
  end

  context 'for unsupported environment' do
    before do
      @original_env = ENV['RACK_ENV']
      ENV['RACK_ENV'] = 'harvey' # force
    end

    after do
      ENV['RACK_ENV'] = @original_env
    end

    it_behaves_like 'valid parameters'

    it 'uses the default configuration' do
      expect(params[:configuration_key][:used]).to eq 'default'
    end
  end
end
