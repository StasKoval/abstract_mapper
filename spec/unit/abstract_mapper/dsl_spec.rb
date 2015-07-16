# encoding: utf-8

class AbstractMapper

  describe AbstractMapper::DSL do

    let!(:dsl) { Class.new { extend DSL } }
    let!(:foo) { Test::Foo = Class.new(Node)    }
    let!(:bar) { Test::Bar = Class.new(Branch)  }

    let!(:rule) do
      Test::Rule = Class.new(PairRule) do
        def optimize?
          left.instance_of?(Test::Foo)
        end

        def optimize
          Test::Foo.new(nodes.flat_map(&:attributes))
        end
      end
    end

    let!(:config) do
      dsl.configure do
        command :foo, Test::Foo
        command :bar, Test::Bar do |*args|
          args.reverse
        end
        rule Test::Rule
      end
    end

    describe "#configure" do

      subject { config }

      it { is_expected.to eql dsl }

      it "configures settings" do
        subject
        expect(dsl.settings).to be_kind_of Settings
        expect(dsl.settings.rules.registry).to eql [rule]
        expect { dsl.settings.commands[:foo] }.not_to raise_error
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

      it { is_expected.to be_kind_of Branch }

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

end # class AbstractMapper
