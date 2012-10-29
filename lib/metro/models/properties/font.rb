module Metro
  class Model

    class FontProperty < Property
      # when retrieved from the properties a font-family and size is returned
      def get(value)
        value = value || { name: Gosu::default_font_name, size: model.size, window: model.window }
        self.class.font_for(value)
      end

      def self.font_for(value)
        name = value[:name]
        size = value[:size]
        window = value[:window]

        font = fonts["#{name}:#{size}:#{window}"]
        unless font
          font = Gosu::Font.new window, name, size
          fonts["#{name}:#{size}:#{window}"] = font
        end

        font
      end

      def self.fonts
        @fonts ||= {}
      end

      def set(value)
        name = value[:name]
        size = value[:size]
        unless self.class.font_for(name,size)
          self.class.fonts["#{font_family}:#{size}"] = Gosu::Font.new(model.window, name, size)
        end
        { name: name, size: size }
      end
    end

  end
end