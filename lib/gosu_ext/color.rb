class Gosu::Color

  alias_method :gosu_initialize, :initialize

  #
  # Monkey-patching the initialize to allow for another Gosu::Color
  # and Strings.
  #
  def initialize(*args)
    if args.length == 1
      value = args.first
      if value.is_a? Gosu::Color
        gosu_initialize value.alpha, value.red, value.green, value.blue
      elsif value.is_a? String
        gosu_initialize value.to_i(16)
      else
        gosu_initialize value
      end
    else
      gosu_initialize *args
    end
  end

end