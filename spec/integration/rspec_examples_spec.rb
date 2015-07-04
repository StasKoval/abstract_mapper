# encoding: utf-8

require_relative "faceter"

require "abstract_mapper/rspec" # examples under the test

describe "rspec examples" do

  include_context "Faceter"

  describe "Faceter::Functions", "#rename_keys" do

    let(:described_class) { Faceter::Functions }

    it_behaves_like :transforming_immutable_data do
      let(:arguments) { [:rename_keys, foo: :bar] }
      let(:input)     { { foo: :FOO, baz: :BAZ }  }
      let(:output)    { { bar: :FOO, baz: :BAZ }  }
    end

  end # describe Faceter::Functions

  describe "Faceter::Rename" do

    let(:described_class) { Faceter::Rename }

    it_behaves_like :creating_immutable_node do
      let(:attributes) { [:foo, to: :bar] }
    end

    it_behaves_like :mapping_immutable_input do
      let(:attributes) { [:foo, to: :bar]         }
      let(:input)      { { foo: :FOO, baz: :BAZ } }
      let(:output)     { { bar: :FOO, baz: :BAZ } }
    end

  end # describe Faceter::Rename

  describe "Faceter::List" do

    let(:described_class) { Faceter::List }

    it_behaves_like :creating_immutable_branch

  end # describe Faceter::List

  describe "Faceter::CompactLists" do

    let(:described_class) { Faceter::CompactLists }

    it_behaves_like :skipping_nodes do
      let(:input) { [Faceter::Rename.new(:foo, to: :bar), Faceter::List.new] }
    end

    it_behaves_like :optimizing_nodes do
      let(:input)  { [Faceter::List.new { [1] }, Faceter::List.new { [2] }] }
      let(:output) { Faceter::List.new { [1, 2] } }
    end

  end # describe Faceter::CompactLists

  describe "Faceter::Mapper" do

    let(:described_class) { Faceter::Mapper }

    it_behaves_like :defining_command do
      let(:name) { :list }
      let(:node) { Faceter::List }
    end

    it_behaves_like :defining_rule do
      let(:rule) { Faceter::CompactLists }
    end

  end # describe Faceter::Mapper

end # describe mapper definition
