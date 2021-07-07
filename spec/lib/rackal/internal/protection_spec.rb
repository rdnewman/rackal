RSpec.describe Rackal::Internal::Protection do
  subject(:apply) { described_class.apply }

  context 'when environment unprotected' do
    before do
      allow(Rackal.environment).to receive(:unprotected?).and_return(true)
    end

    it 'returns false' do
      expect(apply).to eq false
    end
  end

  context 'when environment protected' do
    before do
      allow(Rackal.environment).to receive(:unprotected?).and_return(false)
    end

    if defined?(Refrigerator)
      # Refrigerator won't be present in this gem, so likely never exercised
      # TODO: should the gem provide Refrigerator?
      describe 'and Refrigerator available' do
        it 'returns true' do
          expect(apply).to eq true
        end
      end
    else
      # Refrigerator won't be present in this gem, so likely never exercised
      # TODO: should the gem provide Refrigerator?
      describe 'and Refrigerator is not available' do
        it 'returns false' do
          expect(apply).to eq false
        end
      end
    end

    it 'will not raise a LoadError' do
      expect { apply }.not_to raise_error
    end
  end
end
