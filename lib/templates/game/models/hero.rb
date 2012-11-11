class Hero < Metro::Model

  property :image, path: "hero.png"

  property :position
  property :angle
  property :move_amount, default: 1.5

  event :on_hold, KbLeft, GpLeft do
    self.position -= move_amount
  end

  event :on_hold, KbRight, GpRight do
    self.angle += move_amount
  end

  def draw
    image.draw_rot(x,y,z_order,angle.to_f)
  end
end