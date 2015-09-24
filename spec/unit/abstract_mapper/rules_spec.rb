# encoding: utf-8

describe AbstractMapper::Rules do

  let(:rules) { described_class.new }
  let(:foo)   { Class.new(AbstractMapper::Rules::Sole) }
  let(:bar)   { Class.new(AbstractMapper::Rules::Pair) }

  describe ".new" do
    subject { rules }

    it { is_expected.to be_immutable }
  end # describe .new

  describe "#registry" do
    subject { rules.registry }

    context "by default" do
      let(:rules) { described_class.new }

      it { is_expected.to eql []    }
      it { is_expected.to be_immutable }
    end

    context "initialized" do
      let(:rules)    { described_class.new registry }
      let(:registry) { [foo, bar] }

      it { is_expected.to eql registry }
      it { is_expected.to be_immutable    }
      it "doesn't freeze a source" do
        expect { subject }.not_to change { registry.frozen? }
      end
    end
  end # describe #registry

  describe "#<<" do
    subject { rules << bar }

    let(:rules) { described_class.new [foo] }

    it "returns a collection" do
      expect(subject).to be_kind_of described_class
    end

    it "updates the registry" do
      expect(subject.registry).to eql [foo, bar]
    end
  end # describe #<<

  describe "#[]" do
    subject { rules[nodes] }

    let(:nodes) { [1, 1, 2, 5] }

    context "when no rule is set" do
      it { is_expected.to eql nodes }
    end

    context "when rules are set" do
      let(:rules) { described_class.new [foo, bar, foo] }

      before do
        foo.send(:define_method, :optimize?) { true          }
        foo.send(:define_method, :optimize)  { node + 1      }
        bar.send(:define_method, :optimize?) { left == right }
        bar.send(:define_method, :optimize)  { left + right  }
      end

      it { is_expected.to eql [5, 4, 7] }
      # [1, 1, 2, 5] -foo-> [2, 2, 3, 6] -bar-> [4, 3, 6] -foo-> [5, 4, 7]
    end
  end # describe #[]

end # describe AbstractMapper::Rules
