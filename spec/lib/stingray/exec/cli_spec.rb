require 'stingray/exec/cli'

describe Stingray::Exec::Cli do
  it 'should return zero on success' do
    described_class.main(['two = 1 + 1']).should == 0
  end
end
