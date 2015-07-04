# encoding: utf-8

class AbstractMapper

  # The collection of gem-specific pure functions (transproc)
  #
  # @api private
  #
  module Functions

    extend Transproc::Registry

    uses :map_array, from: Transproc::ArrayTransformations

    # Returns the unchanged value whatever parameters are given
    #
    # @example
    #   fn = Functions[:identity, :foo]
    #   fn[1] # => 1
    #
    # @param [Object] value
    #
    # @return [Object]
    #
    def identity(value, *)
      value
    end

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

    # Applies the function to every consecutive pair of array elements,
    # and removes empty values
    #
    # @example
    #   function = -> a, b { (a == b) ? [a + b] : [a, b] }
    #   fn = Functions[:compact, function]
    #   fn[[1, 1, 2]] # => [4]
    #   fn[[1, 2, 2]] # => [1, 4]
    #
    # @param [Array] array
    # @param [Proc] fn
    #   Anonymous function (proc, lambda), that takes two arguments
    #   and returns an array
    #
    # @return [Array]
    #
    def compact(array, fn)
      array.each_with_object([]) do |i, a|
        if a.empty?
          a << i
        else
          a[-1] = fn.call(a.last, i)
          a.flatten!
        end
      end
    end

    # Checks whether the class or module has given ancestor
    #
    # @example
    #   fn = Functions[:subclass?, Module]
    #   fn[Class]  # => true
    #   fn[Object] # => false
    #
    # @param [Module] subling
    # @param [Module] ancestor
    #
    # @return [Boolean]
    #
    def subclass?(subling, ancestor)
      subling.ancestors.include?(ancestor)
    end

  end # module Functions

end # class AbstractMapper
