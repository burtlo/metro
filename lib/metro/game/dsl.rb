require_relative '../events/controls'

module Metro
  module Game
    class DSL

      def self.parse(&block)
        config = new
        config.instance_eval(&block)
        config
      end

      def first_scene(scene_name = nil)
        scene_name ? @first_scene = scene_name : @first_scene
      end

      def width(game_width = nil)
        game_width ? @width = game_width : @width
      end

      def height(game_height = nil)
        game_height ? @height = game_height : @height
      end

      def resolution(w,h)
        [ width(w), height(h) ]
      end

      def fullscreen(set_fullscreen = nil)
        set_fullscreen.nil? ? @fullscreen : @fullscreen = set_fullscreen
      end

      def debug(set_debug = nil)
        set_debug.nil? ? @debug : @debug = set_debug
      end

      def name(set_name = nil)
        set_name.nil? ? @name : @name = set_name
      end

      def author(name)
        authors.push name
      end

      def authors
        @authors ||= []
      end

      alias_method :artist, :author
      alias_method :designer, :author

      def website(game_website = nil)
        game_website ? @website = game_website : @website
      end

      def contact(game_contact = nil)
        game_contact ? @contact = game_contact : @contact
      end

      def controls(&block)
        @controls ||= Controls.new
        @controls.instance_eval(&block) if block
        @controls
      end

    end
  end
end