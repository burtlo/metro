module Metro
  class Model
    class OptionsProperty

      #
      # When the options cannot find a selected menu option then this no option
      # is returned instead of a nil value. This allows for a warning to be generated
      # if any methods target this item.
      # 
      # Also if the option will send a 'missing_menu_action' if the options were to
      # ask for the selected action.
      # 
      class NoOption
        def method_missing(name,*args,&block)
          log.warn warning_message
        end
        
        def warning_message
          "No valid options were found in the menu"
        end

        def properties
          { action: :missing_menu_action }
        end
      end

    end
  end
end