# encoding: utf-8

describe AbstractMapper::DSL do

  let!(:bar) { AbstractMapper::Test::Bar = Class.new(AbstractMapper::Branch) }
  let!(:foo) { AbstractMapper::Test::Foo = Class.new(AbstractMapper::Node)   }
  let!(:rule) do
    AbstractMapper::Test::Rule = Class.new(AbstractMapper::PairRule) do
      def optimize?
        left.instance_of?(AbstractMapper::Test::Foo)
      end

      def optimize
        AbstractMapper::Test::Foo.new(nodes.flat_map(&:attributes))
      end
    end
  end
  let!(:dsl) { Class.new { extend AbstractMapper::DSL } }

  let!(:config) do
    dsl.configure do
      command :foo, AbstractMapper::Test::Foo
      command :bar, AbstractMapper::Test::Bar
      rule AbstractMapper::Test::Rule
    end
  end

  describe "#configure" do

    subject { config }

    it { is_expected.to eql dsl }

    it "configures settings" do
      subject
      expect(dsl.settings).to be_kind_of AbstractMapper::Settings
      expect(dsl.settings.rules.registry).to eql [rule]
      expect(dsl.settings.commands.registry).to eql(foo: foo, bar: bar)
    end

  end # describe #configure

  describe "#finalize" do

    before do
      dsl.instance_eval do
        bar :baz do
          foo :qux
          foo :quxx
        end
        foo :foo
      end
    end

    subject { dsl.finalize }

    it { is_expected.to be_kind_of AbstractMapper::Branch }

    it "is optimized" do
      expect(subject.inspect)
        .to eql "<Root [<Bar(:baz) [<Foo([:qux, :quxx])>]>, <Foo(:foo)>]>"
    end

  end # describe #finalize

  describe "#respond_to?" do

    subject { dsl.respond_to? :anything }
    it { is_expected.to eql true }

  end # describe #respond_to?

  describe ".inherited" do

    let(:subklass) { Class.new(dsl) }
    subject { subklass.settings }

    it { is_expected.to eql dsl.settings }

  end # describe .inherited

end # describe AbstractMapper::DSL
