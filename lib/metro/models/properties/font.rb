require_relative 'text'

module Metro
  class Model

    class FontProperty < Property

      define_property :size, prefix: true
      define_property :name, type: TextProperty, prefix: true

      get do
        default_font
      end

      get Hash do |value|
        self.class.font_for value.merge(window: model.window)
      end

      set do
        { name: default_font_name, size: default_font_size }
      end

      set Gosu::Font do |font|
        { name: font.name, size: font.height }
      end

      set Hash do |hash|
        hash.symbolize_keys!
      end

      def default_font
        self.class.font_for name: default_font_name,
          size: default_font_size,
          window: model.window
      end

      def default_font_size
        options[:default] ? options[:default][:size] : 40
      end

      def default_font_name
        options[:default] ? options[:default][:name] : Gosu::default_font_name
      end


      def self.font_for(value)
        value.symbolize_keys!
        name = value[:name]
        size = value[:size]
        window = value[:window]

        font = fonts["#{name}:#{size}:#{window}"]
        unless font
          font = create_font(window,name,size)
          fonts["#{name}:#{size}:#{window}"] = font
        end

        font
      end

      def self.create_font(window,name,size)
        Gosu::Font.new window, name, size
      end

      def self.fonts
        @fonts ||= {}
      end

    end

  end
end