# encoding: utf-8

describe AbstractMapper::Builder do

  before do
    AbstractMapper::Test::Builder = Class.new(described_class)
    AbstractMapper::Test::Foo     = Class.new(AbstractMapper::Node)
    AbstractMapper::Test::Bar     = Class.new(AbstractMapper::Branch)
  end

  let(:builder)  { test.new tree                          }
  let(:test)     { AbstractMapper::Test::Builder          }
  let(:commands) { AbstractMapper::Commands.new(registry) }
  let(:tree)     { AbstractMapper::Test::Foo.new          }
  let(:registry) do
    { foo: AbstractMapper::Test::Foo, bar: AbstractMapper::Test::Bar }
  end

  describe ".commands=" do

    subject { test.commands = commands }

    it "sets the commands" do
      expect { subject }.to change { test.commands }.to commands
    end

  end # describe .commands=

  describe ".update" do

    before { test.commands = commands }

    context "by default" do

      subject { test.update }

      it "is an empty branch" do
        expect(subject).to be_instance_of AbstractMapper::Branch
        expect(subject.entries).to be_empty
      end

    end # context

    context "initialized" do

      subject { test.update(tree) }
      it { is_expected.to eql tree }

    end # context

    context "with a block" do

      subject { test.update { bar { foo(:foo) { fail } } } }

      it "is built" do
        expect(subject.inspect).to eql "<Root [<Bar [<Foo(:foo)>]>]>"
        expect(subject.first.first.block).not_to be_nil
      end

    end # context

  end # describe .update

  describe ".new" do

    subject { builder }
    it { is_expected.to be_frozen }

  end # describe .new

  describe "#respond_to?" do

    subject { builder.respond_to? :arbitrary_method }
    it { is_expected.to eql true }

  end # describe #respond_to?

end # describe AbstractMapper::Builder
