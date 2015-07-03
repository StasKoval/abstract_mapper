# encoding: utf-8

require "abstract_mapper/rspec"

describe AbstractMapper::Functions, "#filter" do

  let(:arguments) { [:filter, -> v { v - 1 if v > 3 }] }

  it_behaves_like :transforming_immutable_data do
    let(:input)  { [] }
    let(:output) { [] }
  end

  it_behaves_like :transforming_immutable_data do
    let(:input)  { [1, 4, 9, 7, 2, 5] }
    let(:output) { [3, 8, 6, 4]       }
  end

  it_behaves_like :transforming_immutable_data do
    let(:arguments) { [:filter, -> v { [v - 1] if v > 3 }] }

    let(:input)  { [1, 4, 9, 7, 2, 5] }
    let(:output) { [3, 8, 6, 4]       }
  end

end # describe AbstractMapper::Functions#filter
