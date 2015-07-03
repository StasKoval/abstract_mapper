# encoding: utf-8

describe AbstractMapper do

  let(:test)      { Class.new(described_class)  }
  let(:tree)      { double transproc: transproc }
  let(:transproc) { double                      }

  let(:mapper) do
    allow(transproc).to receive(:call) { |input| "called: #{input}" }
    allow(test).to receive(:finalize) { tree }
    test.new
  end

  describe ".new" do

    subject { mapper }
    it { is_expected.to be_frozen }

  end # describe .new

  describe "#tree" do

    subject { mapper.tree }
    it { is_expected.to eql tree }

  end # describe #tree

  describe "#call" do

    subject { mapper.call :foo }
    it { is_expected.to eql "called: foo" }

  end # describe #call

end # describe AbstractMapper
