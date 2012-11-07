module Metro
  class Scale < Struct.new(:x_factor,:y_factor)

    def self.one
      new 1.0, 1.0
    end

    def self.to(x,y)
      new x.to_f, y.to_f
    end

    def self.parse(string)
      to *string.split(",",2).map(&:to_f)
    end

    def to_s
      "#{x_factor},#{y_factor}"
    end

  end
end