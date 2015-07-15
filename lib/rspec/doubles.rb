# encoding: utf-8

# ==============================================================================
# Doubles for values to be frozen
# ==============================================================================

# Returns the double that can be freezed
#
# @param [Object, Array<Object>] args
#
# @return [Double]
#
def ice_double(*args)
  options = args.last.is_a?(Hash) ? args.pop : {}
  double(*args, options.merge(freeze: nil, frozen?: true))
end
