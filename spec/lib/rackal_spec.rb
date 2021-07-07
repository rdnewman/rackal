RSpec.describe Rackal do
  # TODO: `allow_all_instances_of` is no longer preferred by RSpec, but difficult
  # to avoid here with more targeted techniques without resorting to, say, inheritance
  # to override behavior which seems worse

  describe '.database_parameters' do
    subject(:params) { described_class.database_parameters }

    before do
      allow_any_instance_of(Rackal::Internal::DatabaseConfiguration)
        .to receive(:configuration_directory)
        .and_return('spec/fixtures/config')
    end

    it 'returns Hash' do
      expect(params).to be_instance_of Hash
    end

    it 'is not empty' do
      expect(params.keys).not_to be_empty
    end

    it 'forwards result from Rackal::Internal::DatabaseConfiguration' do
      direct_configuration = Rackal::Internal::DatabaseConfiguration.new.parameters

      expect(params).to eq direct_configuration
    end
  end

  describe '.environment' do
    subject(:environment) { described_class.environment }

    it 'returns a Rackal::Internal::RackEnvironment object' do
      expect(environment).to be_instance_of(Rackal::Internal::RackEnvironment)
    end
  end

  describe '.env (environment variables)' do
    # TODO: need more tests for other env tests maybe?
    it 'retrieves RACK_ENV' do
      expect(described_class.env('RACK_ENV')).to eq 'test'
    end
  end

  describe '.application' do
    subject(:app) { described_class.application }

    before do
      allow_any_instance_of(Rackal::Internal::Application)
        .to receive(:configuration_directory)
        .and_return('spec/fixtures/config')

      stub_const('SomeApp', Class.new)
    end

    it 'returns an object to query about the Application' do
      expect(app).to be_instance_of Rackal::Internal::Application
    end
  end

  describe '.root' do
    subject(:root) { described_class.root }

    before do
      allow_any_instance_of(Rackal::Internal::Application)
        .to receive(:configuration_directory)
        .and_return('spec/fixtures/config')

      stub_const('SomeApp', Class.new)
    end

    it 'returns path ending in "/rackal" (given context of gem)' do
      expect(root).to end_with '/rackal'
    end
  end
end
