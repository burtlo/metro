class Hero < Metro::UI::Sprite

  # A Metro::UI::Sprite predefines a number of commmon properties:
  #
  # * position
  # * dimensions
  # * color
  # * angle
  # * scale
  #
  # These properties add getter and setter methods of the following:
  #
  # * position, x, y, z and z_order (both z and z_order are the same)
  # * dimensions, width, and height
  # * color, red, green, blue, alpha
  # * angle
  # * scale, x_factor, y_factor

  property :image, path: "hero.png"

  property :move_amount, default: 1.5
  property :turn_amount, default: 90.0

  event :on_hold, KbLeft, GpLeft do
    self.x -= move_amount
  end

  event :on_hold, KbRight, GpRight do
    self.x += move_amount
  end

  event :on_hold, KbUp, GpUp do
    self.y -= move_amount
  end

  event :on_hold, KbDown, GpDown do
    self.y += move_amount
  end

  event :on_up, KbSpace do
    self.angle += turn_amount
  end

  # By default a Metro::UI::Sprite defines a #draw method which will
  # draw the associated image with the position, rotation, and scale.
  #
  # If you would like to maintain the current draw functionality but augment
  # it, you can define a draw method which calls to super.
  #
  # def draw
  #   super
  #   # custom drawing alongside the image
  # end
  #
  # You may find it necessary to replace the existing draw functionality.
  # Here you could define your own draw that overrides the original.
  #
  # def draw
  #   # custom drawing without the original image draw
  # end

end