module Metro
  class Model
    class OptionsProperty

      #
      # Options maintains the list of menu options that would be displayed in a menu.
      # Each option is a component that can be rendered during the draw phase.
      #
      # Also, options maintains the currently selected item and has the ability to manage
      # the changes from the previous.
      #
      class Options < SimpleDelegator

        #
        # Generate an empty set of options.
        #
        def self.empty
          new []
        end

        #
        # Create options with the provided array of options.
        #
        # @param [Array] options the array of options that this object will maintain
        #   as it's list of options.
        #
        def initialize(options)
          super(options)
        end

        #
        # @return [Fixnum] the index of the current selected option.
        #
        def current_selected_index
          @current_selected_index ||= 0
        end

        #
        # Set the index of the currently selected item. Values that exceed the possible
        # count of options will reset to the beginning of the list of options.
        # Values that proceed the start of of the list of options will fallback to the last option.
        #
        def current_selected_index=(value)
          @current_selected_index = value || 0
          @current_selected_index = 0 if @current_selected_index >= count
          @current_selected_index = count - 1 if @current_selected_index <= -1
          @current_selected_index
        end

        #
        # @return [Array] a list of all the options that are currently not selected.
        #
        def unselected
          self - [ selected ]
        end

        #
        # @return [Object] the currently selected option.
        #
        def selected
          at(current_selected_index) || NoOption.new
        end

        #
        # @return [Symbol] the action name of the currently selected option. If no
        #   option is currently selected then the NoOption 'missing_menu_action' will be
        #   returned.
        #
        def selected_action
          if selected.respond_to?(:properties) && selected.properties[:action]
            selected.properties[:action]
          else
            selected.to_sym
          end
        end

        #
        # Move the current selected item to the next item
        #
        def next!
          self.current_selected_index += 1
        end

        #
        # Move the current selected item to the previous item
        #
        def previous!
          self.current_selected_index -= 1
        end
      end

    end
  end
end