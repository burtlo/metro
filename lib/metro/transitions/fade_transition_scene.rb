module Metro
  class FadeTransitionScene < TransitionScene

    draw :rectangle, model: "metro::ui::rectangle"

    #
    # When the scene is shown set up the starting color for the rectangle
    # and queue the animation to transition the color to the final color.
    #
    def show
      rectangle.color = starting_color

      color = final_color

      animate :rectangle, to: { red: color.red,
                                green: color.green,
                                blue: color.blue,
                                alpha: color.alpha },
                          interval: interval do

        transition_to next_scene
      end
    end

    def interval
      options[:interval] || default_interval
    end

    def default_interval
      60
    end

    def starting_color
      options_starting_color || default_starting_color
    end

    def options_starting_color
      color_from_options(:from)
    end

    def default_starting_color
      Gosu::Color.new "rgb(255,255,255)"
    end

    def final_color
      options_final_color || default_final_color
    end

    def options_final_color
      color_from_options(:to)
    end

    def default_final_color
      Gosu::Color.new "rgb(0,0,0)"
    end

    def color_from_options(position)
      if options[position]
        if options[position][:color]
          Gosu::Color.new options[position][:color]
        end
      end
    end

  end
end