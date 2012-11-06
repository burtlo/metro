module Metro
  class Model

    #
    # The numeric property will simply convert any input into a floating
    # point value. This is the same both on getting and setting.
    #
    class NumericProperty < Property

      # For all cases the value is converted to floating point when it can
      # otherwise the default number is used.
      get_or_set do |value|
        if value.is_a?(NilClass)
          default_number
        elsif value.respond_to?(:to_f)
          value.to_f
        else
          default_number
        end
      end

      def default_number
        options[:default].to_f
      end

    end

  end
end