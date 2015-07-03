# encoding: utf-8

shared_context "Faceter" do

  before do
    module Faceter

      # Transproc functions
      module Functions
        extend Transproc::Registry

        uses :map_array,   from: Transproc::ArrayTransformations
        uses :rename_keys, from: Transproc::HashTransformations
      end

    end # module Faceter

  end # before

  after { Object.send :remove_const, :Faceter }

end # shared context
