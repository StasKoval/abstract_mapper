# encoding: utf-8

describe AbstractMapper::Branch do

  let(:foo) do
    class Foo < AbstractMapper::Node
      def transproc
        AbstractMapper::Functions[-> v { "#{v}-1" }]
      end
    end
    Foo
  end

  let(:node1)  { foo.new }
  let(:node2)  { foo.new }
  let(:node3)  { foo.new }
  let(:branch) { test.new(:foo) { [node1, node2] } }
  let(:test)   { AbstractMapper::Test::Foo = Class.new(described_class) }

  describe ".new" do

    subject { branch }

    it { is_expected.to be_kind_of Enumerable }
    it { is_expected.to be_frozen             }

    context "without a block" do

      subject { test.new(:foo).entries }
      it { is_expected.to be_empty }

    end # context

    context "with a block" do

      subject { test.new(:foo) { [node1, node2] }.entries }
      it { is_expected.to eql [node1, node2] }

    end # context

  end # describe .new

  describe "#block" do

    subject { branch.block }
    it { is_expected.to be_nil }

  end # describe #block

  describe "#rebuild" do

    subject { branch.rebuild { [node2, node3] } }

    it { is_expected.to be_kind_of test }

    it "preserves attributes" do
      expect(subject.attributes).to eql branch.attributes
    end

    it "assings new subnodes from a block" do
      expect(subject.entries).to eql [node2, node3]
    end

  end # describe #rebuild

  describe "#each" do

    let(:subnodes) { [node1, node2] }

    context "with a block" do

      subject { branch.each { |item| item } }

      it "looks over subnodes" do
        expect(subject).to eql subnodes
      end

    end # context

    context "without a block" do

      subject { branch.each }

      it "returns Enumerator for subnodes" do
        expect(subject).to be_kind_of Enumerator
        expect(subject.entries).to eql subnodes
      end

    end # context

  end # describe #each

  describe "#<<" do

    subject { branch << node3 }

    it "returns the branch with updated subnodes and the same attributes" do
      expect(subject).to be_kind_of test
      expect(subject.attributes).to eql branch.attributes
      expect(subject.entries).to eql [node1, node2, node3]
    end

  end # describe #<<

  describe "#transproc" do

    let(:data) { "baz" }

    subject { branch.transproc[data] }
    it { is_expected.to eql "baz-1-1" }

  end # describe #transproc

  describe "#to_s" do

    subject { branch.to_s }

    context "of the root" do

      let(:branch) { described_class.new { [node1, node2] } }
      it { is_expected.to eql "Root [#{node1.inspect}, #{node2.inspect}]" }

    end # context

    context "of the specific node" do

      let(:branch) { test.new(:foo) { [node1, node2] } }
      it { is_expected.to eql "Foo(:foo) [#{node1.inspect}, #{node2.inspect}]" }

    end # context

  end # describe #to_s

end # describe Branch
