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
        def initialize(hash)
          @hash = hash
          super
        end

        def transproc
          Functions[:rename_keys, @hash]
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

      class CompactRenames < AbstractMapper::PairRule
        def optimize?
          left.is_a?(Rename) && right.is_a?(Rename)
        end

        def optimize
          Rename.new left.attributes.first.merge(right.attributes.first)
        end
      end

      # Registry
      class Mapper < AbstractMapper
        configure do
          command :list,   Faceter::List
          command :rename, Faceter::Rename do |name, options|
            [name => options.fetch(:to)]
          end

          rule Faceter::CompactLists
          rule Faceter::CompactRenames
        end
      end

    end # module Faceter

  end # before

  after { Object.send :remove_const, :Faceter }

end # shared context
