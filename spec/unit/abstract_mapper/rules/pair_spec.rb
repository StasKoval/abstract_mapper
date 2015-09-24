# encoding: utf-8

describe AbstractMapper::Rules::Pair do

  let(:rule)  { test.new(left, right) }
  let(:test)  { Class.new(described_class) }
  let(:nodes) { [left, right] }
  let(:left)  { AbstractMapper::AST::Node.new   }
  let(:right) { AbstractMapper::AST::Node.new   }

  describe ".new" do

    subject { rule }

    it { is_expected.to be_kind_of AbstractMapper::Rules::Base }
    it { is_expected.to be_immutable }

    it "requires second argument" do
      expect { test.new(left) }.to raise_error(ArgumentError)
    end

  end # describe .new

  describe "#left" do

    subject { rule.left }
    it { is_expected.to eql left }

  end # describe #left

  describe "#right" do

    subject { rule.right }
    it { is_expected.to eql right }

  end # describe #right

  describe "#transproc" do

    before do
      test.send(:define_method, :optimize?) { left == right }
      test.send(:define_method, :optimize)  { left + right  }
    end

    let(:array) { [1, 1, 2, 5] }

    subject { test.transproc[array] }
    it { is_expected.to eql [4, 5] }

  end # describe #transproc

end # describe AbstractMapper::Rules::Pair
