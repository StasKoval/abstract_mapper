# encoding: utf-8

require "transproc/rspec"

describe AbstractMapper::Functions, "#restrict" do
  let(:arguments) { [:restrict, default] }
  let(:default)   { { foo: :FOO, bar: :BAR } }

  it_behaves_like :transforming_immutable_data do
    let(:input)  { { foo: :BAZ, qux: :QUX } }
    let(:output) { { foo: :BAZ, bar: :BAR } }
  end
end # describe AbstractMapper::Functions#restrict
