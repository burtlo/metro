#
# The lib folder is a great place for you to define:
#
# * New Units
# * Monkey Patches for Metro
# * New model properties
# * Custom Easings
# * Custom View Parers/Writers
# * Anything that isn't quite a model, scene, or view
#

#
# This custom easing is an exact copy of the 'Ease In' easing defined in Metro.
# It is present here as an example.
#
class CustomEasing < Metro::Easing

  #
  # @param [Float] moment the point in time within the interval. For example for
  #   a 60 tick interval, this would be the values 0, 1, 2, 3, 4, 5, 6, ... 59.
  # @param [Float] start the starting value of the property
  # @param [Float] change the final value for the property
  # @param [Float] interval the total length of the interval
  #
  # @return [Float] the value at the particular moment of the interval
  def self.calculation(moment,start,change,interval)
    # @note this is the exact same as the already defined Ease In
    change * (moment = moment / interval) * moment + start
  end
end

Metro::Easing.register :custom, CustomEasing