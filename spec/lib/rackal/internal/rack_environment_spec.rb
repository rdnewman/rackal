RSpec.describe Rackal::Internal::RackEnvironment do
  subject(:environment) { described_class.new(protect_test: true) }

  context 'for testing' do
    # this environment is default in RSpec so no need to amend

    it 'is not nil' do
      expect(environment).not_to be_nil
    end

    it 'is :test' do
      expect(environment.env).to eq :test
    end

    it 'matches what Rack reports' do
      expect(environment.env).to eq ENV['RACK_ENV'].to_sym
    end

    it 'is supported' do
      expect(environment.supported?).to eq true
    end

    it 'is not unsupported' do
      expect(environment.unsupported?).to eq false
    end

    it 'is test environment' do
      expect(environment.test?).to eq true
    end

    it 'is not development' do
      expect(environment.development?).to eq false
    end

    it 'is not staging' do
      expect(environment.staging?).to eq false
    end

    it 'is not production' do
      expect(environment.production?).to eq false
    end

    describe 'when protect_test is true' do
      # protect_test already true in the subject

      it 'is protected' do
        expect(environment.protected?).to eq true
      end

      it 'is not unprotected' do
        expect(environment.unprotected?).to eq false
      end
    end

    context 'when protect_test is false' do
      subject(:environment) { described_class.new(protect_test: false) }

      it 'is not protected' do
        expect(environment.protected?).to eq false
      end

      it 'is unprotected' do
        expect(environment.unprotected?).to eq true
      end
    end
  end

  context 'for unsupported environment' do
    before do
      @original_env = ENV['RACK_ENV']
      ENV['RACK_ENV'] = 'harvey' # force
    end

    after do
      ENV['RACK_ENV'] = @original_env # restore
    end

    it 'is not nil' do
      expect(environment).not_to be_nil
    end

    it 'is :harvey' do
      expect(environment.env).to eq :harvey
    end

    it 'matches what Rack reports' do
      expect(environment.env).to eq ENV['RACK_ENV'].to_sym
    end

    it 'is not protected' do
      expect(environment.protected?).to eq false
    end

    it 'is unprotected' do
      expect(environment.unprotected?).to eq true
    end

    it 'is not supported' do
      expect(environment.supported?).to eq false
    end

    it 'is unsupported' do
      expect(environment.unsupported?).to eq true
    end

    it 'is not test environment' do
      expect(environment.test?).to eq false
    end

    it 'is not development' do
      expect(environment.development?).to eq false
    end

    it 'is not staging' do
      expect(environment.staging?).to eq false
    end

    it 'is not production' do
      expect(environment.production?).to eq false
    end
  end
end
