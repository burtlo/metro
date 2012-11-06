module Metro
  class Point < Struct.new(:x,:y)
    def self.zero
      new 0.0, 0.0
    end

    def self.at(x,y)
      new x, y
    end
  end
end