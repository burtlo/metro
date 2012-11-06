module Metro
  class Model

    class NumericProperty < Property

      get_or_set do |value|
        value ? value.to_f : default_number
      end

      def default_number
        options[:default].to_f
      end

    end

  end
end