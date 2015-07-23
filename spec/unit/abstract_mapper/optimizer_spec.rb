# encoding: utf-8

class AbstractMapper # namespace

  describe AbstractMapper::Optimizer do

    let(:optimizer) { test.new rules             }
    let(:test)      { Class.new(described_class) }
    let(:rules)     { Rules.new                  }

    describe ".new" do

      subject { optimizer }
      it { is_expected.to be_frozen }

    end # describe .new

    describe "#rules" do

      subject { optimizer.rules }
      it { is_expected.to eql rules }

    end # describe #rules

    describe "#update" do

      subject { optimizer.update(tree) }

      let(:rules) { Rules.new([rule])           }
      let(:rule)  { Class.new(PairRule)         }
      let(:tree)  { Branch.new { [foo3, bar1] } }

      let(:foo1) { Test::Foo.new(n: 1)                  }
      let(:foo2) { Test::Foo.new(n: 2)                  }
      let(:foo3) { Test::Foo.new(n: 3)                  }
      let(:bar1) { Test::Bar.new(n: 4) { [foo1, foo2] } }

      before { Test::Foo = Class.new(Node) { attribute :n }            }
      before { Test::Bar = Class.new(Branch)                           }
      before { rule.send(:define_method, :optimize?) { true }          }
      before { rule.send(:define_method, :optimize)  { nodes.reverse } }

      it "optimizes the tree deeply" do
        expect(tree.inspect)
          .to eql "<Root [<Foo(n: 3)>, <Bar [<Foo(n: 1)>, <Foo(n: 2)>]>]>"
        expect(subject.inspect)
          .to eql "<Root [<Bar [<Foo(n: 2)>, <Foo(n: 1)>]>, <Foo(n: 3)>]>"
      end

    end # describe #update

  end # describe AbstractMapper::Optimize

end # class AbstractMapper
