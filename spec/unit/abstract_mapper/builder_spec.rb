# encoding: utf-8

class AbstractMapper

  describe AbstractMapper::Builder do

    let!(:test) { Class.new(described_class)                          }
    let!(:foo)  { Test::Foo = Class.new(AST::Node) { attribute :foo } }
    let!(:bar)  { Test::Bar = Class.new(AST::Branch)                  }

    let(:builder)  { test.new tree }
    let(:tree)     { Test::Foo.new }
    let(:commands) { Commands.new << [:foo, Test::Foo] << [:bar, Test::Bar] }

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
          expect(subject).to be_instance_of AST::Branch
          expect(subject.entries).to be_empty
        end
      end

      context "initialized" do
        subject { test.update(tree) }

        it "returns exactly the same tree" do
          expect(subject.inspect).to eql(tree.inspect)
        end
      end

      context "with a block" do
        subject { test.update { bar { foo(foo: :FOO) { fail } } } }

        it "is built" do
          expect(subject.inspect).to eql "<Root [<Bar [<Foo(foo: :FOO)>]>]>"
          expect(subject.first.first.block).not_to be_nil
        end
      end
    end # describe .update

    describe ".new" do
      subject { builder }

      it { is_expected.to be_frozen }

      it "doesn't freezes the tree" do
        expect { subject }.not_to change { tree.frozen? }
      end
    end # describe .new

    describe "#tree" do
      subject { builder.tree }

      it "returns exactly the same tree as initialized" do
        expect(subject.inspect).to eql tree.inspect
      end

      it { is_expected.to be_immutable }
    end # describe #tree

    describe "#respond_to?" do
      subject { builder.respond_to? :arbitrary_method }

      it { is_expected.to eql true }
    end # describe #respond_to?

  end # describe AbstractMapper::Builder

end # class AbstractMapper
