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

end # describe mapper definition
