# encoding: utf-8

describe AbstractMapper::Rules do

  let(:rules) { described_class.new }
  let(:foo) { AbstractMapper::Test::Foo = Class.new(AbstractMapper::SoleRule) }
  let(:bar) { AbstractMapper::Test::Bar = Class.new(AbstractMapper::PairRule) }

  describe ".new" do

    subject { rules }
    it { is_expected.to be_frozen }

  end # describe .new

  describe "#registry" do

    subject { rules.registry }

    context "by default" do

      let(:rules) { described_class.new }
      it { is_expected.to eql []    }
      it { is_expected.to be_frozen }

    end # context

    context "initialized" do

      let(:rules)    { described_class.new registry }
      let(:registry) { [foo, bar]                 }

      it { is_expected.to eql registry }
      it { is_expected.to be_frozen    }

      it "doesn't freezes the source" do
        expect { subject }.not_to change { registry.frozen? }
      end

    end # context

  end # describe #registry

  describe "#<<" do

    subject { rules << bar }

    let(:rules) { described_class.new [foo] }

    it "updates the registry" do
      expect(subject).to be_kind_of described_class
      expect(subject.registry).to eql [foo, bar]
    end

  end # describe #<<

  describe "#[]" do

    before do
      foo.send(:define_method, :optimize?) { true          }
      foo.send(:define_method, :optimize)  { node + 1      }
      bar.send(:define_method, :optimize?) { left == right }
      bar.send(:define_method, :optimize)  { left + right  }
    end

    context "when no rule is set" do

      let(:nodes) { [1, 1, 2, 5] }

      subject { rules[nodes] }
      it { is_expected.to eql nodes }

    end # context

    context "when rules are set" do

      let(:rules) { described_class.new [foo, bar, foo] }
      let(:nodes) { [1, 1, 2] }

      subject { rules[nodes] }
      it { is_expected.to eql [6, 4] }
      # [1, 1, 2] -foo-> [2, 2, 3] -foo-> [3, 3, 4] -bar-> [6, 4]

    end # context

  end # describe #[]

end # describe AbstractMapper::Rules
