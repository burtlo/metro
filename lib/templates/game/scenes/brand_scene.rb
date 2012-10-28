class BrandScene < Metro::Scene

  draws :brand

  event :on_up, Gosu::KbEscape, Gosu::KbSpace, Gosu::GpButton0 do

    animate :brand, to: { alpha: 0 }, interval: 60 do
      transition_to :brand_to_title
    end

  end

end