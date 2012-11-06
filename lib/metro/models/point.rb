module Metro
  class Point < Struct.new(:x,:y,:z)
    def self.zero
      new 0.0, 0.0, 0.0
    end

    def self.at(x,y,z=0.0)
      new x.to_f, y.to_f, z.to_f
    end

    def self.parse(string)
      at *string.split(",",3).map(&:to_f)
    end

    alias_method :z_order, :z
    alias_method :z_order=, :z=

    def to_s
      "#{x},#{y},#{z}"
    end

  end
end