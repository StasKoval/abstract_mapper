# encoding: utf-8

describe AbstractMapper::Settings do

  let!(:rule) do
    AbstractMapper::Test::Rule = Class.new(AbstractMapper::SoleRule)
  end
  let!(:node) do
    AbstractMapper::Test::Node = Class.new(AbstractMapper::Node)
  end

  let(:settings) do
    described_class.new do
      command :foo, AbstractMapper::Test::Node
      rule AbstractMapper::Test::Rule
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
          expect(error).to be_kind_of AbstractMapper::Errors::WrongNode
          expect(error.message).to include "String"
        end
      end

    end # context

    context "with invalid rule" do

      subject { described_class.new { rule String } }
      it "fails" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of AbstractMapper::Errors::WrongRule
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

    it { is_expected.to be_kind_of AbstractMapper::Commands }

    it "contains registered commands" do
      expect(subject.registry).to eql(foo: node)
    end

  end # describe #commands

  describe "#rules" do

    subject { settings.rules }

    it { is_expected.to be_kind_of AbstractMapper::Rules }

    it "contains registered rules" do
      expect(subject.registry).to eql [rule]
    end

  end # describe #rules

  describe "#builder" do

    subject { settings.builder }

    it "subclasses AbstractMapper::Builder" do
      expect(subject.superclass).to eql AbstractMapper::Builder
    end

    it "uses registered commands" do
      expect(subject.commands).to eql settings.commands
    end

  end # describe #builder

  describe "#optimizer" do

    subject { settings.optimizer }

    it { is_expected.to be_kind_of AbstractMapper::Optimizer }

    it "uses registered rules" do
      expect(subject.rules).to eql settings.rules
    end

  end # describe #optimizer

end # describe AbstractMapper::Settings
