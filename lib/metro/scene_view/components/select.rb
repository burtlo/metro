module Metro
  module SceneView
    class Select < Drawer
      draws 'select'

      attr_accessor :selected_index, :options

      def after_initialize
        name, content = scene.view.find { |name,content| content['type'].to_sym == :select }

        if content
          @selected_index = 0
          @options = content['options']
          events = EventRelay.new(self,window)

          events.on_up Gosu::KbLeft, Gosu::GpLeft, Gosu::KbUp, Gosu::GpUp, do: :previous_option
          events.on_up Gosu::KbRight, Gosu::GpRight, Gosu::KbDown, Gosu::GpDown, do: :next_option
          events.on_up Gosu::KbEnter, Gosu::KbReturn, Gosu::GpButton0, do: :selection

          scene.add_event_relay events
        end
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

      def draw(view)
        view['options'].each_with_index do |option,index|

          color = view["color"] || 0xffffffff

          if index == selected_index
            color = view["highlight-color"] || 0xffffff00
          end

          color = color.to_i(16) if color.is_a? String

          y_position = view["y"] + view["padding"] * index
          font.draw option, view["x"], y_position, Metro::Game::UI, 1.0, 1.0, color
        end
      end

    end
  end
end