# encoding: utf-8

class AbstractMapper # namespace

  describe AbstractMapper::Node do

    let(:test) do
      Test::Node = Class.new(described_class) do
        attribute "foo"
        attribute :bar, default: :BAR
      end
    end

    let(:node)       { test.new(attributes, &block) }
    let(:attributes) { { foo: :FOO }                }
    let(:block)      { nil                          }

    describe ".new" do

      subject { node }

      it "initializes attributes" do
        expect(subject.foo).to eql :FOO
        expect(subject.bar).to eql :BAR
      end

      it { is_expected.to be_frozen }

      it "doesn't freeze the source" do
        expect { subject }.not_to change { attributes.frozen? }
      end

    end # describe .new

    describe "#attributes" do

      subject { node.attributes }

      it { is_expected.to eql({ foo: nil, bar: :BAR }.merge(attributes)) }

      context "by default" do

        let(:node) { test.new }
        it { is_expected.to eql(foo: nil, bar: :BAR) }

      end # context

    end # describe #attributes

    describe "#block" do

      subject { node.block }

      context "when block is absent" do

        it { is_expected.to eql nil }

      end # context

      context "when block is present" do

        let(:block) { proc { :foo }   }
        it { is_expected.to eql block }

      end # context

    end # describe #block

    describe "#to_s" do

      subject { node.to_s }

      context "with uninitialized attributes" do

        let(:node) { test.new }
        it { is_expected.to eql "Node(foo: nil, bar: :BAR)" }

      end # context

      context "with initialized attributes" do

        let(:node) { test.new(attributes) }
        it { is_expected.to eql "Node(foo: :FOO, bar: :BAR)" }

      end # context

      context "without attributes" do

        let(:node) { described_class.new }
        it { is_expected.to eql "Node" }

      end # context

    end # describe #to_s

    describe "#==" do

      subject { node == other }

      context "node with the same type and attributes" do

        let(:other) { test.new(attributes) }
        it { is_expected.to eql true }

      end # context

      context "node with other type" do

        let(:other) { Class.new(test).new(attributes) }
        it { is_expected.to eql false }

      end # context

      context "node with other attributes" do

        let(:other) { test.new }
        it { is_expected.to eql false }

      end # context

    end # describe #==

    describe "#inspect" do

      subject { node.inspect }
      it { is_expected.to eql "<Node(foo: :FOO, bar: :BAR)>" }

    end # describe #inspect

    describe "#transproc" do

      subject { node.transproc }

      it "returns the identity function" do
        expect(subject[:foo]).to eql :foo
      end

    end # describe #transproc

  end # describe AbstractMapper::Node

end # class AbstractMapper
