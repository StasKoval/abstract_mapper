# encoding: utf-8

require_relative "faceter"

describe "mapper definition" do

  include_context "Faceter"

  before do
    class MyMapper < Faceter::Mapper
      list do
        rename :foo, to: :baz
      end

      list do
        rename :bar, to: :qux
      end
    end
  end

  let(:mapper) { MyMapper.new }
  let(:input)  { [{ foo: :FOO, bar: :FOO }, { foo: :BAR, bar: :BAR }] }
  let(:output) { [{ baz: :FOO, qux: :FOO }, { baz: :BAR, qux: :BAR }] }

  it "works" do
    expect(mapper.tree.inspect)
      .to eql "<Root [<List [<Rename({:foo=>:baz, :bar=>:qux})>]>]>"
    expect(mapper.call input).to eql output
  end

  after { Object.send :remove_const, :MyMapper }

end # describe mapper definition
