# encoding: utf-8

class AbstractMapper

  # The collection of gem-specific pure functions (transproc)
  #
  # @api private
  #
  module Functions

    extend Transproc::Registry

    uses :map_array, from: Transproc::ArrayTransformations

    # Applies the function to every element of array and removes empty values
    #
    # @example
    #   fn = Functions[:filter, -> v { v - 1 if v > 3 }]
    #   fn[[1, 4, 5, 3, 2, 5, 9]]
    #   # => [3, 4, 4, 8]
    #
    # @param [Array] array
    # @param [Proc] fn
    #
    # @return [Array]
    #
    def filter(array, fn)
      map_array(array, fn).compact.flatten
    end

  end # module Functions

end # class AbstractMapper
