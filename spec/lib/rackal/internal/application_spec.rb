RSpec.describe Rackal::Internal::Application do
  # TODO: `allow_all_instances_of` is no longer preferred by RSpec, but difficult
  # to avoid here with more targeted techniques without resorting to, say, inheritance
  # to override behavior which seems worse

  subject(:app) { described_class.new }

  context 'with test configuration (fixture)' do
    before do
      allow_any_instance_of(described_class)
        .to receive(:configuration_directory)
        .and_return('spec/fixtures/config')

      stub_const('SomeApp', Class.new)
    end

    it 'test configuration returns SomeApp as the main application' do
      expected_configuration = { rackal: { 'app_main' => 'SomeApp' } }

      expect(app.read_configuration('rackal')).to eq expected_configuration
    end

    it '#main_class returns application class' do
      expect(app.main_class).to be SomeApp
    end

    context 'when in gem test context' do
      it '#root returns path ending in /rackal' do
        expect(app.root).to end_with '/rackal'
      end
    end

    context 'when config.ru is in call stack,' do
      before do
        # stub the Kernel version when first invoked, but then allow it to
        # eventually be called.  The ...::Test::MockConfigru invokes it
        # to force config.ru to be in the call stack
        # load 'fixtures/root/by_configru/config.ru'
        load 'support/mocked_path/by_configru/config.ru'
        allow(app).to receive(:caller_locations).once do
          # Rackal::Internal::Test::MockConfigru.forced_call_stack
          Rackal::Internal::Test::MockedPath::Configru.forced_call_stack
        end
      end

      it '#root returns mocked path where support file exists' do
        expect(app.root).to end_with '/spec/support/mocked_path/by_configru'
      end
    end

    context 'when application is in call stack,' do
      before do
        # stub the Kernel version when first invoked, but then allow it to
        # eventually be called.  The ...::Test::MockedPath::Application invokes it
        # to force some_app.rb to be in the call stack
        # load 'fixtures/root/by_app_filename/some_app.rb'
        load 'support/mocked_path/by_app_filename/some_app.rb'
        allow(app).to receive(:caller_locations).once do
          Rackal::Internal::Test::MockedPath::Application.forced_call_stack
        end
      end

      it '#root returns mocked path where support file exists' do
        expect(app.root).to end_with '/spec/support/mocked_path/by_app_filename'
      end
    end
  end

  context 'with empty configuration' do
    before do
      allow_any_instance_of(described_class)
        .to receive(:read_configuration)
        .and_return({})
    end

    it 'test configuration returns an empty hash' do
      expected_configuration = {}

      expect(app.read_configuration('rackal')).to eq expected_configuration
    end

    it '#main_class raises NameError' do
      expect { app.main_class }.to raise_error NameError
    end
  end

  context 'when configuration does not contain :rackal key' do
    before do
      allow_any_instance_of(described_class)
        .to receive(:read_configuration)
        .and_return({ xrackal: { 'app_main' => 'SomeApp' } })
    end

    it '#main_class raises NameError' do
      expect { app.main_class }.to raise_error NameError
    end
  end
end
