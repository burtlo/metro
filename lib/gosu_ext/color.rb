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
        gosu_initialize *Array(self.class.parse_string(value))
      end
    else
      gosu_initialize *args
    end
  end

  def self.parse_string(value)
    parse_hex(value) || parse_rgb(value) || parse_rgba(value) || [ 255, 255, 255, 255 ]
  end

  def self.parse_rgba(rgba)
    if rgba =~ /rgba\(([\d]{1,3}),([\d]{1,3}),([\d]{1,3}),(\d(?:\.\d)?)\)/
      [ (255 * $4.to_f).floor.to_i, $1.to_i, $2.to_i, $3.to_i ]
    end
  end

  def self.parse_rgb(rgb)
    if rgb =~ /rgb\(([\d]{1,3}),([\d]{1,3}),([\d]{1,3})\)/
      [ 255, $1.to_i, $2.to_i, $3.to_i ]
    end
  end

  def self.parse_hex(hex)
    if hex =~ /#([A-Fa-f0-9]{6})/
      "0xFF#{$1}".to_i(16)
    end
  end

end