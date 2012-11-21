class Hero < Metro::Model

  property :image, path: "hero.png"

  property :position
  property :angle
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

  def draw
    image.draw_rot(x,y,z_order,angle.to_f)
  end
end