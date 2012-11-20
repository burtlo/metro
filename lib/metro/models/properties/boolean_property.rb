module Metro
  class Model

    #
    # The boolean property will simply convert any input into a true or
    # false value.
    #
    class BooleanProperty < Property

      # For all cases the value is converted to floating point when it can
      # otherwise the default number is used.
      get_or_set do |value|
        if value.is_a?(NilClass)
          default_value
        else
          !!value
        end
      end

      def default_value
        !!options[:default]
      end

    end

  end
end