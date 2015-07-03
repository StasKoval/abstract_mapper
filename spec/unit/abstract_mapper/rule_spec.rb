# encoding: utf-8

describe AbstractMapper::Rule do

  let(:rule)  { test.new(*nodes) }
  let(:test)  { AbstractMapper::Test::Rule = Class.new(described_class) }
  let(:nodes) { [node] }
  let(:node)  { double }

  describe ".new" do

    subject { rule }
    it { is_expected.to be_frozen }

  end # describe .new

  describe "#nodes" do

    subject { rule.nodes }

    it { is_expected.to eql nodes }
    it { is_expected.to be_frozen }

    it "doesn't freeze the source" do
      expect { subject }.not_to change { nodes.frozen? }
    end

  end # describe #nodes

  describe "#call" do

    subject { rule.call }

    before { test.send(:define_method, :optimize?) { true }  }
    before { test.send(:define_method, :optimize) { [:foo] } }

    context "when #optimize? returns true" do

      before { test.send(:define_method, :optimize?) { true } }
      it { is_expected.to eql [:foo] }

    end # context

    context "when #optimize? returns false" do

      before { test.send(:define_method, :optimize?) { false } }
      it { is_expected.to eql [node] }

    end # context

    context "when #optimize returns non-array" do

      before { test.send(:define_method, :optimize) { :foo } }
      it { is_expected.to eql [:foo] }

    end # contex

    context "when #optimize returns nils" do

      before { test.send(:define_method, :optimize) { [nil, nil] } }
      it { is_expected.to eql [] }

    end # contex

  end # describe #call

  describe ".transproc" do

    before do
      test.send(:define_method, :optimize?) { true          }
      test.send(:define_method, :optimize)  { nodes.reverse }
      allow(test).to receive(:composer)     { :compact      }
    end

    subject { test.transproc[array] }

    let(:array) { [1, 2, 3] }

    it { is_expected.to eql [2, 3, 1] }

  end # describe .transproc

end # describe AbstractMapper::Rule
