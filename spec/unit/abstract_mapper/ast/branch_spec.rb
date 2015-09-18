# encoding: utf-8

describe AbstractMapper::AST::Branch do

  let(:foo) do
    class Foo < AbstractMapper::AST::Node
      attribute :foo

      def transproc
        AbstractMapper::Functions[-> v { "#{v}-1" }]
      end
    end
    Foo
  end
  let(:node1)  { foo.new foo: :FOO }
  let(:node2)  { foo.new foo: :BAR }
  let(:node3)  { foo.new foo: :BAZ }
  let(:branch) { test.new(foo: :FOO) { [node1, node2] } }
  let(:test) do
    AbstractMapper::Test::Foo = Class.new(described_class) do
      attribute :foo
    end
  end

  describe ".new" do
    subject { branch }

    it { is_expected.to be_kind_of Enumerable }
    it { is_expected.to be_frozen             }

    context "without a block" do
      subject { test.new(foo: :FOO).entries }

      it { is_expected.to be_empty }
    end

    context "with a block" do
      subject { test.new(foo: :FOO) { [node1, node2] }.entries }

      it { is_expected.to eql [node1, node2] }
    end
  end # describe .new

  describe "#attributes" do
    subject { branch.attributes }

    context "initialized" do
      it { is_expected.to eql(foo: :FOO) }
    end

    context "not initialized" do
      let(:branch) { test.new }

      it { is_expected.to eql(foo: nil) }
    end

    context "not defined" do
      let(:branch) { described_class.new }

      it { is_expected.to eql({}) }
    end
  end # describe #attributes

  describe "#block" do
    subject { branch.block }

    it { is_expected.to be_nil }
  end # describe #block

  describe "#update" do
    subject { branch.update { [node2, node3] } }

    it { is_expected.to be_kind_of test }

    it "preserves attributes" do
      expect(subject.attributes).to eql(foo: :FOO)
    end

    it "assings new subnodes from a block" do
      expect(subject.entries).to eql [node2, node3]
    end
  end # describe #update

  describe "#each" do
    let(:subnodes) { [node1, node2] }

    context "with a block" do
      subject { branch.each { |item| item } }

      it "looks over subnodes" do
        expect(subject).to eql subnodes
      end
    end

    context "without a block" do
      subject { branch.each }

      it "returns Enumerator for subnodes" do
        expect(subject).to be_kind_of Enumerator
        expect(subject.entries).to eql subnodes
      end
    end
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
    subject { branch.transproc[data] }

    let(:data) { "baz" }

    it { is_expected.to eql "baz-1-1" }
  end # describe #transproc

  describe "#to_s" do
    subject { branch.to_s }

    context "of the root" do
      let(:branch) { described_class.new { [node1, node2] } }

      it { is_expected.to eql "Root [#{node1.inspect}, #{node2.inspect}]" }
    end

    context "of the specific node" do
      let(:branch) { test.new(foo: :FOO) { [node1, node2] } }

      it do
        is_expected
          .to eql "Foo(foo: :FOO) [#{node1.inspect}, #{node2.inspect}]"
      end
    end
  end # describe #to_s

  describe "#eql?" do
    subject { branch.eql? other }

    context "with the same type, attributes and subnodes" do
      let(:other) { test.new(foo: :FOO) { [node1, node2] } }

      it { is_expected.to eql true }
    end

    context "with another type" do
      let(:other) { Class.new(test).new(foo: :FOO) { [node1, node2] } }

      it { is_expected.to eql false }
    end

    context "with other attributes" do
      let(:other) { test.new(foo: :BAR) { [node1, node2] } }

      it { is_expected.to eql false }
    end

    context "with other subnodes" do
      let(:other) { test.new(foo: :FOO) { [node1, node3] } }

      it { is_expected.to eql false }
    end
  end # describe #eql?

end # describe AbstractMapper::AST::Branch
