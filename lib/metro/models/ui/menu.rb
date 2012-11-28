module Metro
  module UI

    #
    # Draws a a menu of options. A menu model inserts itself into the scene as an event
    # target as it needs to maintain the state of the menu. When an option is selected
    # an event is fired based on the name of the option.
    #
    # @note Only one 'menu' can be defined for a given scene
    #
    # @example Creating a menu with basic options
    #
    #     menu:
    #       model: metro::ui::menu
    #       position: "472.0,353.0,5.0"
    #       alpha: 0
    #       unselected_color: "rgba(119,119,119,1.0)"
    #       selected_color: "rgba(255,255,255,1.0)"
    #       options: [ 'Start Game', 'Exit' ]
    #
    # @example Creating a menu with a selected item
    #
    #     menu:
    #       model: metro::ui::menu
    #       position: "472.0,353.0,5.0"
    #       alpha: 0
    #       unselected_color: "rgba(119,119,119,1.0)"
    #       selected_color: "rgba(255,255,255,1.0)"
    #       options:
    #         selected: 0
    #         items: [ 'Start Game', 'Exit' ]
    #
    #
    # @example Creating a menu with complex options
    #
    #     menu:
    #       model: metro::ui::menu
    #       position: "472.0,353.0,5.0"
    #       alpha: 0
    #       layout: vertical
    #       # layout: horizontal
    #       unselected_color: "rgba(119,119,119,1.0)"
    #       selected_color: "rgba(255,255,255,1.0)"
    #       options:
    #         selected: 1
    #         items:
    #         -
    #           model: "metro::ui::label"
    #           text: "Start Game"
    #           action: start_game
    #         -
    #           model: metro::ui::label
    #           text: Exit
    #           action: exit_game
    #
    #
    class Menu < Model

      property :position, default: Game.center
      property :alpha, default: 255

      property :scale, default: Scale.one

      property :padding, default: 20

      property :dimensions do
        Dimensions.of (right_x - left_x), (bottom_y - top_y)
      end

      property :options

      property :unselected_color, type: :color, default: "rgba(119,119,119,1.0)"
      property :selected_color, type: :color, default: "rgba(255,255,255,1.0)"

      def alpha_changed(alpha)
        adjust_alpha_on_colors(alpha)
        options.each { |option| option.alpha = alpha.floor }
      end

      def adjust_alpha_on_colors(alpha)
        self.selected_color_alpha = alpha
        self.unselected_color_alpha = alpha
      end

      property :selection_sample, type: :sample, path: "menu-selection.wav"
      property :movement_sample, type: :sample, path: "menu-movement.wav"

      property :enabled, type: :boolean, default: true

      # Allows the menu to be layouted out horizontal or vertical
      property :layout, type: :text, default: "vertical"

      def bounds
        Bounds.new left: left_x, right: right_x, top: top_y, bottom: bottom_y
      end

      #
      # When the position has changed on every other time beside the first time
      # we want to update the position of all the options defined in the menu.
      #
      def position_changed(new_position)
        return unless properties[:position]
        difference = Point.parse(new_position) - Point.parse(properties[:position])
        options.each { |option| option.position += difference }
      end

      def left_x
        options.map {|option| option.bounds.left }.min
      end

      def right_x
        options.map {|option| option.bounds.right }.max
      end

      def top_y
        options.map {|option| option.bounds.top }.min
      end

      def bottom_y
        options.map {|option| option.bounds.bottom }.max
      end

      # @TODO: enable the user to define the events for this interaction
      #################################################################

      event :on_up, KbLeft, GpLeft, KbUp, GpUp do
        if enabled
          movement_sample.play
          options.previous!
          update_options
        end
      end

      event :on_up, KbRight, GpRight, KbDown, GpDown do
        if enabled
          movement_sample.play
          options.next!
          update_options
        end
      end

      event :on_up, KbEnter, KbReturn, GpButton0 do
        if enabled
          selection_sample.play
          scene.send options.selected_action
        end
      end

      #################################################################

      def show
        adjust_alpha_on_colors(alpha)

        previous_width = 0

        options.each_with_index do |option,index|
          option.color = unselected_color
          option.scale = scale

          option_x = x + (layout == "horizontal" ? (previous_width + padding) * index : 0)
          previous_width = option.width
          option_y = y + (layout == "vertical" ? (option.height + padding) * index : 0)
          option_z = z

          option.position = option.position + Point.at(option_x,option_y,option_z)

        end

        options.selected.color = selected_color
      end

      def update_options
        options.unselected.each { |option| option.color = unselected_color }
        options.selected.color = selected_color
      end

      def draw
        options.each { |label| label.draw }
      end

    end
  end
end