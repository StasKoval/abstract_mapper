# encoding: utf-8

require "transproc/rspec"

describe AbstractMapper::Functions, "#identity" do

  it_behaves_like :transforming_immutable_data do
    let(:arguments) { [:identity] }

    let(:input)  { :foo }
    let(:output) { :foo }
  end

  it_behaves_like :transforming_immutable_data do
    let(:arguments) { [:identity, :bar, :baz] }

    let(:input)  { :foo }
    let(:output) { :foo }
  end

end # describe AbstractMapper::Functions#identity
