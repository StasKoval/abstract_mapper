# encoding: utf-8

class AbstractMapper

  describe AbstractMapper::Commands do

    let(:foo)       { Test::Foo = Class.new(AbstractMapper::Branch) }
    let(:bar)       { Test::Bar = Class.new(AbstractMapper::Node)   }
    let(:test)      { Class.new(described_class)                    }
    let(:commands)  { test.new                                      }
    let(:converter) { -> v { v.reverse }                            }

    describe ".new" do

      let(:registry) { { foo: foo, bar: bar } }
      subject { test.new(registry) }

      it { is_expected.to be_frozen }

      it "doesn't freeze arguments" do
        expect { subject }.not_to change { registry.frozen? }
      end

    end # describe .new

    describe "#[]" do

      subject { commands << ["foo", foo] }

      it "returns registered command" do
        expect(subject["foo"]).to be_kind_of Commands::Base
      end

      it "complains about unknown command" do
        expect { subject[:baz] }.to raise_error do |error|
          expect(error).to be_kind_of AbstractMapper::Errors::UnknownCommand
          expect(error.message).to include "baz"
        end
      end

    end # describe #[]

    describe "#<<" do

      subject { commands << ["foo", foo] << ["bar", bar, converter] }

      it { is_expected.to be_kind_of test }

      it "preserves registered commands" do
        expect(subject[:foo]).to be_kind_of Commands::Base
      end

      it "registers new command" do
        expect(subject[:bar]).to be_kind_of Commands::Base
        expect(subject[:bar].name).to eql :bar
        expect(subject[:bar].klass).to eql bar
        expect(subject[:bar].converter).to eql converter
      end

    end # describe #<<

  end # describe AbstractMapper::Commands

end # class AbstractMapper
