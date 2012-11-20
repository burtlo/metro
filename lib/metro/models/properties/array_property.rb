module Metro
  class Model

    #
    # The array property will simply store or retrieve an array.
    #
    class ArrayProperty < Property

      get do |value|
        value.is_a?(NilClass) ? default_value : Array(value)
      end

      set do |value|
        Array(value).map {|item| item }
      end

      def default_value
        options[:default] or []
      end

    end

  end
end
