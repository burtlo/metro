class BrandScene < Metro::Scene

  draws :brand

  event :confirmation do
    animate :brand, to: { alpha: 0 }, interval: 60 do
      transition_to :brand_to_title
    end
  end

end