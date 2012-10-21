module Metro
  module Models

    #
    # Draws a a menu of options. It is called a Select as it is named after the HTML
    # element select. A select model also inserts itself into the scene as an event
    # target as it needs to maintain the state of the menu. When an option is selected
    # an event is fired based on the name of the option.
    #
    # @note Only one 'select' can be defined for a given scene.
    #
    class Select < Model
      attr_accessor :selected_index, :options

      def scene=(value)
        @scene = value
        
        @selected_index = 0

        events = EventRelay.new(self,window)

        events.on_up Gosu::KbLeft, Gosu::GpLeft, Gosu::KbUp, Gosu::GpUp, do: :previous_option
        events.on_up Gosu::KbRight, Gosu::GpRight, Gosu::KbDown, Gosu::GpDown, do: :next_option
        events.on_up Gosu::KbEnter, Gosu::KbReturn, Gosu::GpButton0, do: :selection

        scene.add_event_relay events
      end

      def selection
        scene_method = options[selected_index].downcase.gsub(/\s/,'_')
        scene.send scene_method
      end

      def previous_option
        @selected_index = @selected_index - 1
        @selected_index = options.length - 1 if @selected_index <= -1
      end

      def next_option
        @selected_index = @selected_index + 1
        @selected_index = 0 if @selected_index >= options.length
      end

      def font
        @font ||= Gosu::Font.new(window, Gosu::default_font_name, 20)
      end

      attr_reader :highlight_color

      def highlight_color=(value)
        @highlight_color = _convert_color(value)
      end

      def alpha=(value)
        color.alpha = value.floor
        highlight_color.alpha = value.floor
      end

      def draw
        options.each_with_index do |option,index|

          draw_color = color
          draw_color = highlight_color if index == selected_index

          y_position = y + padding * index
          font.draw option, x, y_position, Metro::Game::UI, 1.0, 1.0, draw_color
        end
      end

    end
  end
end