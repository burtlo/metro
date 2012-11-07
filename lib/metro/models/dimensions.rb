module Metro
  class Dimensions < Struct.new(:width,:height)

    def self.none
      new 0.0, 0.0
    end

    def self.of(width,height)
      new width.to_f, height.to_f
    end

    def self.parse(string)
      to *string.split(",",2).map(&:to_f)
    end

    def to_s
      "#{width},#{height}"
    end

  end
end
