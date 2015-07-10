# encoding: utf-8

describe AbstractMapper do

  let(:mapper) do
    allow(test).to receive(:finalize) { tree }
    test.new
  end

  let(:test) { Class.new(described_class)  }

  let(:tree) { klass.new }

  let(:klass) do
    Class.new(AbstractMapper::Branch) do
      def transproc
        -> v { "called: #{v}" }
      end
    end
  end

  describe ".new" do

    subject { mapper }
    it { is_expected.to be_frozen }

  end # describe .new

  describe "#tree" do

    subject { mapper.tree }
    it { is_expected.to eql tree }
    it { is_expected.to be_frozen }

  end # describe #tree

  describe "#call" do

    subject { mapper.call :foo }
    it { is_expected.to eql "called: foo" }

  end # describe #call

end # describe AbstractMapper
