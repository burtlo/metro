class BrandScene < GameScene

  draws :brand

  after 2.seconds do
    transition_to_brand_to_title
  end

  event :confirmation do
    transition_to_brand_to_title
  end

  def transition_to_brand_to_title
    animate :brand, to: { alpha: 0 }, interval: 1.second do
      transition_to :brand_to_title
    end
  end

end
