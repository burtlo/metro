module Tmx
  module ObjectShape
    extend self

    module ShapeDefaults
      def default_sensor
        false
      end

      def default_elasticity
        0.0
      end

      def default_shape_attach_point
        CP::Vec2::ZERO
      end
    end

    class PolyShape
      include ShapeDefaults

      def match?(object)
        object.contents['shape'] == 'polygon'
      end

      def shape(object)
        new_shape = CP::Shape::Poly.new(object.body,poly_vec2s(object),default_shape_attach_point)
        new_shape.collision_type = object.type.to_sym
        new_shape.e = default_elasticity
        new_shape.sensor = default_sensor
        new_shape
      end

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
      def poly_vec2s(object)
        object.points.map do |point|
          x,y = point.split(",").map {|p| p.to_i }
          CP::Vec2.new(x,y)
        end.reverse
      end

    end

    class CircularShape
      include ShapeDefaults

      def match?(object)
        object.contents['shape'] == 'ellipse'
        # raise "Only circular shapes are allowed to be specified" if (object.width / 2) != (object.height / 2)
      end

      def shape(object)
        radius = object.width / 2
        offset = CP::Vec2.new(0,0)
        new_shape = CP::Shape::Circle.new(object.body, radius, offset)
        new_shape.collision_type = object.type.to_sym
        new_shape.e = default_elasticity
        new_shape.sensor = default_sensor
        new_shape
      end

    end

    class UnknownShape
      def match?(object)
        true
      end

      def shape(object)
        raise "Invalid Shape defined in Object: #{object}"
      end
    end

    def shapes
      [ PolyShape.new, CircularShape.new, UnknownShape.new ]
    end

    def create_from_tmx_object(object)
      shapes.find { |shape| shape.match?(object) }.shape(object)
    end

  end
end

