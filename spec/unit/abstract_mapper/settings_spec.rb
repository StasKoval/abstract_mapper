# encoding: utf-8

class AbstractMapper

  describe AbstractMapper::Settings do

    let!(:rule) { Test::Rule = Class.new(Rules::Sole) }
    let!(:node) { Test::Node = Class.new(AST::Node) { attribute :foo } }

    let(:settings) do
      described_class.new do
        command :foo, Test::Node do |value|
          { foo: value }
        end

        rule Test::Rule
      end
    end

    describe ".new" do

      context "with a valid block" do

        subject { settings }
        it { is_expected.to be_frozen }

      end # context

      context "with invalid command" do

        subject { described_class.new { command :foo, String } }

        it "fails" do
          expect { subject }.to raise_error do |error|
            expect(error).to be_kind_of Errors::WrongNode
            expect(error.message).to include "String"
          end
        end

      end # context

      context "with invalid rule" do

        subject { described_class.new { rule String } }

        it "fails" do
          expect { subject }.to raise_error do |error|
            expect(error).to be_kind_of Errors::WrongRule
            expect(error.message).to include "String"
          end
        end

      end # context

      context "without a block" do

        subject { described_class.new }

        it "doesn't fail" do
          expect { subject }.not_to raise_error
        end

      end # context

    end # describe .new

    describe "#commands" do

      subject { settings.commands }

      it { is_expected.to be_kind_of Commands }

      it "contains registered commands" do
        node = subject[:foo].call(:bar)
        expect(node.inspect).to eql "<Node(foo: :bar)>"
      end

    end # describe #commands

    describe "#rules" do

      subject { settings.rules }

      it { is_expected.to be_kind_of Rules }

      it "contains registered rules" do
        expect(subject.registry).to eql [rule]
      end

    end # describe #rules

    describe "#builder" do

      subject { settings.builder }

      it "subclasses Builder" do
        expect(subject.superclass).to eql Builder
      end

      it "uses registered commands" do
        expect(subject.commands).to eql settings.commands
      end

    end # describe #builder

    describe "#optimizer" do

      subject { settings.optimizer }

      it { is_expected.to be_kind_of Optimizer }

      it "uses registered rules" do
        expect(subject.rules).to eql settings.rules
      end

    end # describe #optimizer

  end # describe Settings

end # class AbstractMapper
