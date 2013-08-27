module Metro
  module UI

    #
    # A physics sprite is a Metro model that is specially designed to draw and
    # manage an image. A sprite maintains an image, location information, and
    # rotation. It also has a physics body and shape to assist with being
    # placed within a `Metro::UI::Space`.
    #
    class PhysicsSprite < Sprite

      # @attribute
      # The mass specified here is given to the body.
      property :mass, default: 10

      # @attribute
      # The moment of inertia determines how the sprite will react to the forces
      # applied to it.
      property :moment_of_interia, default: 1000000

      # @attribute
      # A physics sprite has by default a collision shape that is a square.
      # So this property defines the length of one side which is used to create
      # the appropriately sized shape for the sprite.
      property :shape_size, default: 120.0

      # @attribute
      # The name of the shape. This name is important when the space defines
      # actions based on the collision of particular objects. By default all
      # physics sprites are named 'object'.
      property :shape_name, type: :text, default: "object"

      # @attribute
      # When this value is true the bounding box will be placed around the
      # sprite. This is useful in determining correct sizes and collisions.
      property :debug, type: :boolean, default: false

      # @return the body of the physics sprite that is created with the mass
      #   and moment of interia specified in the other properties.
      def body
        @body ||= begin
          body = CP::Body.new(mass,moment_of_interia)
          body.p = CP::Vec2::ZERO
          body.v = CP::Vec2::ZERO
          body.a = 0
          body
        end
      end

      # @return a polygon shape for the physics sprite with the size based on
      #   the `shape_size` property value.
      def shape
        @shape ||= begin
          poly_array = [ [ -1 * shape_size, -1 * shape_size ],
            [ -1 * shape_size, shape_size ],
            [ shape_size, shape_size ],
            [ shape_size, -1 * shape_size ] ].map do |x,y|
              CP::Vec2.new(x,y)
          end

          new_shape = CP::Shape::Poly.new(body,poly_array, CP::Vec2::ZERO)
          new_shape.collision_type = shape_name.to_sym
          new_shape.e = 0.0
          new_shape

        end
      end

      # An helper method that makes it easy to apply an impulse to the body at
      # the center of the body. The impulse provided is in two parameters, the
      # x and y component.
      def push(x_amount,y_amount)
        body.apply_impulse(CP::Vec2.new(x_amount,y_amount),CP::Vec2.new(0.0, 0.0))
      end

      # Upon the scene start the body is assigned the x and y position. If this
      # method is overriden the position will need to be set manually.
      def show
        body.p = CP::Vec2.new(x,y)
      end

      # On update track the position of the sprite based on the position of the
      # physics body.
      def update
        self.x = body.p.x
        self.y = body.p.y
      end

      # On draw, draw the specified sprite.
      def draw
        angle_in_degrees = body.a.radians.to_degrees
        image.draw_rot(x,y,z_order,angle_in_degrees)

        draw_bounding_box if debug
      end

      def draw_bounding_box
        @bounding_box_border ||= create "metro::ui::border"
        @bounding_box_border.position = Point.at(position.x - shape_size,shape.bb.t)
        @bounding_box_border.dimensions = Dimensions.of(shape.bb.r - shape.bb.l,shape.bb.b - shape.bb.t)
        @bounding_box_border.draw
      end
    end
  end
end