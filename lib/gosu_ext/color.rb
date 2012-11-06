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
      else
        gosu_initialize value
      end
    else
      gosu_initialize *args
    end
  end

  def self.parse_string(value)
    parse_hex(value) || parse_rgb(value) || parse_rgba(value) || parse_gosu_color_string(value) || [ 255, 255, 255, 255 ]
  end

  def self.parse_rgba(rgba)
    if rgba =~ /rgba\(([\d]{1,3}(?:\.\d*)?),([\d]{1,3}(?:\.\d*)?),([\d]{1,3}(?:\.\d*)?),(\d(?:\.\d*)?)\)/
      [ (255 * $4.to_f).floor.to_i, $1.to_i, $2.to_i, $3.to_i ]
    end
  end

  def self.parse_rgb(rgb)
    if rgb =~ /rgb\(([\d]{1,3}),([\d]{1,3}),([\d]{1,3})\)/
      [ 255, $1.to_i, $2.to_i, $3.to_i ]
    end
  end

  def self.parse_hex(hex)
    if hex =~ /0x([A-Fa-f0-9]{8})/
      hex.to_i(16)
    elsif hex =~ /#([A-Fa-f0-9]{6})/
      "0xFF#{$1}".to_i(16)
    end
  end

  def self.parse_gosu_color_string(string)
    if string =~ /\(ARGB: ([\d]{1,3})\/([\d]{1,3})\/([\d]{1,3})\/([\d]{1,3})\)/
      [ $1.to_i, $2.to_i, $3.to_i, $4.to_i ]
    end
  end

  def to_s
    "rgba(#{red},#{green},#{blue},#{alpha / 255.to_f})"
  end

  def to_json(*params)
    to_s.to_json
  end

end