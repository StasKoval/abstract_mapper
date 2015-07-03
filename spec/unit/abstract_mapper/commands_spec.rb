# encoding: utf-8

describe AbstractMapper::Commands do

  let(:commands) { test.new                   }
  let(:test)     { Class.new(described_class) }
  let(:branch)   { Class.new(AbstractMapper::Branch)  }

  describe ".new" do

    subject { commands }
    it { is_expected.to be_frozen }

  end # describe .new

  describe "#registry" do

    subject { commands.registry }

    context "with a hash" do

      let(:commands) { test.new(registry) }
      let(:registry) { { foo: branch }    }

      it { is_expected.to eql registry }
      it { is_expected.to be_frozen    }

      it "doesn't freeze the source" do
        expect { subject }.not_to change { registry.frozen? }
      end

    end # context

    context "without a hash" do

      let(:commands) { test.new }

      it { is_expected.to eql({})   }
      it { is_expected.to be_frozen }

    end # context

  end # describe #builder

  describe "#<<" do

    let(:commands) { test.new(foo: branch) }

    subject { commands << ["bar", branch] }

    it "registers a command" do
      expect(subject).to be_kind_of test
      expect(subject.registry).to eql(foo: branch, bar: branch)
    end

  end # describe #<<

  describe "#[]" do

    let(:block) { proc { [:foo] }   }
    let(:args)  { [:baz, qux: :QUX] }
    let(:commands) do
      test.new(foo: AbstractMapper::Node, bar: AbstractMapper::Branch)
    end

    context "simple node" do

      subject { commands["foo", *args, &block] }

      it "builds a node with a block" do
        expect(subject).to be_kind_of AbstractMapper::Node
        expect(subject.attributes).to eql args
        expect(subject.block).to eql block
      end

    end # context

    context "branch command" do

      subject { commands["bar", *args, &block] }

      it "builds a branch" do
        expect(subject).to be_kind_of AbstractMapper::Node
        expect(subject.attributes).to eql args
        expect(subject.entries).to eql []
      end

    end # context

    context "unknown command" do

      subject { commands["baz"] }

      it "fails" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of AbstractMapper::Errors::UnknownCommand
          expect(error.message).to include "baz"
        end
      end

    end # context

  end # describe #build

end # describe AbstractMapper::Commands
