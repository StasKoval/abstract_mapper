# encoding: utf-8

describe AbstractMapper::Node do

  let(:test)       { AbstractMapper::Test::Node = Class.new(described_class) }
  let(:node)       { test.new(*attributes)                           }
  let(:attributes) { [:foo, :bar]                                    }

  describe ".new" do

    subject { node }
    it { is_expected.to be_frozen }

  end # describe .new

  describe "#attributes" do

    subject { node.attributes }

    it { is_expected.to eql attributes }
    it { is_expected.to be_frozen      }

    it "doesn't freeze the source" do
      expect { subject }.not_to change { attributes.frozen? }
    end

  end # describe #attributes

  describe "#block" do

    subject { node.block }

    context "when block is absent" do

      let(:node) { test.new(*attributes) }
      it { is_expected.to eql nil }

    end # context

    context "when block is present" do

      let(:block) { proc { :foo }                 }
      let(:node)  { test.new(*attributes, &block) }
      it { is_expected.to eql block }

    end # context

  end # describe #block

  describe "#to_s" do

    subject { node.to_s }

    context "without attributes" do

      let(:node) { test.new }
      it { is_expected.to eql "Node" }

    end # context

    context "with attributes" do

      let(:node) { test.new(*attributes) }
      it { is_expected.to eql "Node(:foo, :bar)" }

    end # context

  end # describe #to_s

  describe "#inspect" do

    subject { node.inspect }
    it { is_expected.to eql "<Node(:foo, :bar)>" }

  end # describe #inspect

  describe "#transproc" do

    subject { node.transproc[:foo] }
    it { is_expected.to eql :foo }

  end # describe #transproc

end # describe AbstractMapper::Node
