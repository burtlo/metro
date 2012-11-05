module Metro
  class Point < Struct.new(:x,:y)

  end

  class Scale < Struct.new(:x_factor,:y_factor)

    def self.default
      new 1.0, 1.0
    end

    def self.to(x,y)
      new x.to_f, y.to_f
    end

  end
end

