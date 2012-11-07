module Metro
  class Model

    #
    # A text property maintains a string of text
    #
    # Text is stored as text in properties. When retrieving the text, the contents of the text will
    # be evaluated within the instance of the model's scene. Which means that text may contain
    # escaped variables referencing anything in the scene or the game.
    #
    # @example Defining a text property
    #
    #     class Scoreboard < Metro::Model
    #       property :text
    #
    #       def draw
    #         font.draw text, x, y, z_order, x_factor, y_factor, color
    #       end
    #
    #     end
    #
    # @example Defining with a default and text that will be instance evaluated.
    #
    #     class ScoreBoard < Metro::Model
    #       property :text, default: 'Score is #{player.score}'
    #     end
    #
    # @example Using a text property with a different property name
    #
    #     class Hero < Metro::Model
    #       property :description, type: :text
    #
    #       def draw
    #         description_font.draw description, x, y, z_order, x_factor, y_factor, color
    #       end
    #     end
    #
    class TextProperty < Property

      # When no text is found for the field use the default text.
      get do |value|
        evalute_within_scene default_text
      end

      # When getting the text, evaluate the text within the scene.
      get String do |value|
        evalute_within_scene(value)
      end

      # When saving, simply save whatever is given as text.
      set do |value|
        value.to_s
      end

      def evalute_within_scene(text)
        model.scene.instance_eval( "\"#{text}\"" )
      end

      def default_text
        options[:default] || 'TEXT NOT SPECIFIED!'
      end

    end

  end
end