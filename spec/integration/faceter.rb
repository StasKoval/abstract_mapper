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

      # Nodes
      class List < AbstractMapper::Branch
        def transproc
          Functions[:map_array, super]
        end
      end

      class Rename < AbstractMapper::Node
        def initialize(old, options = {})
          @old = old
          @new = options.fetch(:to)
          super
        end

        def transproc
          Functions[:rename_keys, @old => @new]
        end
      end

      # Rules
      class CompactLists < AbstractMapper::PairRule
        def optimize?
          left.is_a?(List) && right.is_a?(List)
        end

        def optimize
          List.new { left.entries + right.entries }
        end
      end

      # Registry
      class Mapper < AbstractMapper
        configure do
          command :list,   Faceter::List
          command :rename, Faceter::Rename

          rule Faceter::CompactLists
        end
      end

    end # module Faceter

  end # before

  after { Object.send :remove_const, :Faceter }

end # shared context
