module Metro
  class Model

    #
    # An options property is a property that takes scene or view defined values
    # and converts them into an Options object.
    #
    # @see Metro::Model::OptionsProperty::Options
    #
    # @example A simple array of option names
    #
    #     options: [ 'Start Game', 'Exit' ]
    #
    #
    # @example A set of option names with a selection
    #
    #       options:
    #         selected: 0
    #         items: [ 'Start Game', 'Exit' ]
    #
    # @example A complex set of options
    #
    #       options:
    #         selected: 1
    #         items:
    #         -
    #           model: "metro::ui::label"
    #           text: "Start Game"
    #           action: start_game
    #         -
    #           model: metro::ui::label
    #           text: Exit
    #           action: exit_game
    #
    class OptionsProperty < Property

      get do |options|
        Options.empty
      end

      # This is the basic set of options
      get Array do |options|
        parse_array(options)
      end

      # This is the complex set of options
      get Hash do |options|
        parse(options)
      end

      # This is setting the options with the basic set of options
      set Array do |array|
        array
      end

      # This is setting the options with the complex options
      set Hash, HashWithIndifferentAccess do |hash|
        hash.to_hash
      end

      private

      def parse_array(array)
        hash = { items: array }
        parse(hash)
      end

      #
      # Convert the hash of parameters into an Options object which contains the visual
      # representation of each item within the menu as well as the current selected item.
      #
      def parse(hash)
        hash = hash.with_indifferent_access
        options = create_options(hash[:items])
        options.current_selected_index = hash[:selected]
        options
      end

      def create_options(items)
        create_options_with_items convert_simple_items(items)
      end

      #
      # As menu options can be defined in many ways, this method will convert the simple
      # versions of the content to match the full robust version by converting them to a
      # hash and adding the remaining fields.
      #
      def convert_simple_items(items)
        return items if items.first.is_a?(Hash)
        items.map { |text| { model: "metro::ui::label", text: text } }
      end

      #
      # Generate an Options object with the options specified.
      #
      # @see Options
      #
      def create_options_with_items(options)
        Options.new options.map { |option| create_model_from_item(option) }
      end

      #
      # From the options provided create the models that will be managed by the Options
      # object.
      #
      def create_model_from_item(options)
        options = options.symbolize_keys
        options[:action] = actionize(options[:action] || options[:text])
        model.create options[:model], options
      end

      #
      # @return [Symbol] convert a text string into a name which would be a sane method name.
      #
      def actionize(text)
        text.to_s.downcase.gsub(/\s/,'_').gsub(/^[^a-zA-Z]*/,'').gsub(/[^a-zA-Z0-9\s_]/,'').to_sym
      end

    end

  end
end

require_relative 'options'
require_relative 'no_option'
