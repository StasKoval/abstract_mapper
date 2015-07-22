# encoding: utf-8

describe AbstractMapper::Optimizer do

  let(:optimizer) { test.new rules             }
  let(:test)      { Class.new(described_class) }
  let(:rules)     { AbstractMapper::Rules.new          }

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

    let(:rules) { AbstractMapper::Rules.new([rule])             }
    let(:rule)  { Class.new(AbstractMapper::PairRule)           }
    let(:tree)  { AbstractMapper::Branch.new { [node3, node4] } }

    let(:node1) { AbstractMapper::Node.new(n: 1)                         }
    let(:node2) { AbstractMapper::Node.new(n: 2)                         }
    let(:node3) { AbstractMapper::Node.new(n: 3)                         }
    let(:node4) { AbstractMapper::Test::Foo.new(n: 4) { [node1, node2] } }

    before { AbstractMapper::Test::Foo = Class.new(AbstractMapper::Branch) }
    before { rule.send(:define_method, :optimize?) { true }                }
    before { rule.send(:define_method, :optimize)  { nodes.reverse }       }

    it "optimizes the tree deeply" do
      expect(tree.inspect)
        .to eq "<Root [<Node(n: 3)>, <Foo(n: 4) [<Node(n: 1)>, <Node(n: 2)>]>]>"
      expect(subject.inspect)
        .to eq "<Root [<Foo(n: 4) [<Node(n: 2)>, <Node(n: 1)>]>, <Node(n: 3)>]>"
    end

  end # describe #update

end # describe AbstractMapper::Optimize
