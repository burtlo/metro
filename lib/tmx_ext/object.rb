module Tmx

  class Object

    #
    # A TMX object currently has an array of points in a format
    # list of strings. This will convert the points into
    # list of CP::Vec2 objects which can be used to create the
    # proper CP::Shape::Poly for the Object.
    #
    # @note this assumes that we want to convert the points into
    #   a format of vec2s specifically for a CP::Shape::Poly
    #   shape.
    #
    def poly_vec2s
      points.map do |point|
        x,y = point.split(",").map {|p| p.to_i }
        CP::Vec2.new(x,y)
      end.reverse
    end

    # TODO: the mass and moment of interia should configurable through properties
    def body
      @body ||= CP::Body.new default_mass, default_moment_of_inertia
    end

    def poly_shape
      @poly_shape ||= begin
        new_shape = CP::Shape::Poly.new(body,poly_vec2s,default_shape_attach_point)
        new_shape.collision_type = type.to_sym
        new_shape.e = default_elasticity
        new_shape.sensor = default_sensor
        new_shape
      end
    end

    alias_method :shape, :poly_shape

    private

    def default_sensor
      false
    end

    def default_mass
      Float::INFINITY
    end

    def default_moment_of_inertia
      Float::INFINITY
    end

    def default_elasticity
      0.0
    end

    def default_shape_attach_point
      CP::Vec2::ZERO
    end

  end

end