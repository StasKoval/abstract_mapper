# encoding: utf-8

class AbstractMapper

  describe AbstractMapper::Settings do

    let!(:foo) { Test::Foo = Class.new(AST::Node) { attribute :foo } }
    let!(:bar) { Test::Bar = Class.new(AST::Node) { attribute :bar } }

    let!(:baz) { Test::Baz = Class.new(Rules::Sole) }
    let!(:qux) { Test::Qux = Class.new(Rules::Sole) }

    let(:settings) do
      described_class.new do
        command(:foo, Test::Foo) { |value| { foo: value } }
        rule Test::Baz
      end
    end

    describe ".new" do
      context "with a valid block" do
        subject { settings }

        it { is_expected.to be_frozen }
      end

      context "with invalid command" do
        subject { described_class.new { command :foo, String } }

        it "fails" do
          expect { subject }.to raise_error do |error|
            expect(error).to be_kind_of Errors::WrongNode
            expect(error.message).to include "String"
          end
        end
      end

      context "with invalid rule" do
        subject { described_class.new { rule String } }

        it "fails" do
          expect { subject }.to raise_error do |error|
            expect(error).to be_kind_of Errors::WrongRule
            expect(error.message).to include "String"
          end
        end
      end

      context "without a block" do
        subject { described_class.new }

        it "doesn't fail" do
          expect { subject }.not_to raise_error
        end
      end
    end # describe .new

    describe "#commands" do
      subject { settings.commands }

      it { is_expected.to be_kind_of Commands }

      it "contains registered commands" do
        node = subject[:foo].call(:FOO)
        expect(node.inspect).to eql "<Foo(foo: :FOO)>"
      end
    end # describe #commands

    describe "#rules" do
      subject { settings.rules }

      it { is_expected.to be_kind_of Rules }

      it "contains registered rules" do
        expect(subject.registry).to eql [baz]
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

    describe "#update" do
      subject do
        settings.update do
          command(:bar, Test::Bar) { |value| { bar: value } }
          rule Test::Qux
        end
      end

      it { is_expected.to be_kind_of described_class }

      it "updates commands" do
        node = subject.commands[:foo].call(:FOO)
        expect(node.inspect).to eql "<Foo(foo: :FOO)>"

        node = subject.commands[:bar].call(:BAR)
        expect(node.inspect).to eql "<Bar(bar: :BAR)>"
      end

      it "updates rules" do
        expect(subject.rules.registry).to eql [baz, qux]
      end
    end # describe #update

  end # describe Settings

end # class AbstractMapper
