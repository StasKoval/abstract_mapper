# encoding: utf-8

describe AbstractMapper::PairRule do

  let(:rule)  { test.new(left, right)                           }
  let(:test)  { AbstractMapper::Test::Rule = Class.new(described_class) }
  let(:nodes) { [left, right]                                   }
  let(:left)  { double                                          }
  let(:right) { double                                          }

  describe ".composer" do

    subject { test.composer }
    it { is_expected.to eql :compact }

  end # describe .pair?

  describe ".new" do

    subject { rule }

    it { is_expected.to be_kind_of AbstractMapper::Rule }
    it { is_expected.to be_frozen }

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

    subject { test.transproc[array] }

    let(:array) { [1, 1, 2, 5] }
    it { is_expected.to eql [4, 5] }

  end # describe #transproc

end # describe AbstractMapper::PairRule
