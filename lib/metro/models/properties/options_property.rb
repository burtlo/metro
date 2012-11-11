module Metro
  class Model

    class Options < Array
      def selected
        unless found = find { |option| option.selected? }
          found = at(0)
          found.select!
          puts "Setting first as selected #{found}"
        end
        
        found
      end
      
      def previous
        current_selected = selected
        current_selected.unselect!
        at( (index(current_selected) - 1) % count ).select!
      end
      
      def next
        current_selected = selected
        current_selected.unselect!
        at( (index(current_selected) + 1) % count ).select!
      end

      def to_a
        map { |option| option.to_hash }
      end
    end

    #
    # The Option represents a choice within the menu.
    #
    class Option
      attr_reader :data

      def name
        @data[:name]
      end

      def method
        @data[:method] || name.to_s.downcase.gsub(/\s/,'_').gsub(/^[^a-zA-Z]*/,'').gsub(/[^a-zA-Z0-9\s_]/,'')
      end

      def selected?
        !!@data[:selected]
      end

      def select!
        @data[:selected] = true
      end
      
      def unselect!
        @data[:selected] = false
      end

      def initialize(data)
        data = { name: data } unless data.is_a?(Hash)
        @data = data
      end

      def to_hash
        { name: name, method: method, selected: selected? }
      end
    end

    class OptionsProperty < Property

      # By default, getting the options property will generate the default options
      get do

      end

      # By default, setting the options property will save the default options
      set do

      end

      get Array do |array|
        build_options(array)
      end

      set Options do |value|
        puts "Saving Options: #{value.to_a}"
        value.to_a
      end

      def build_options(raw_options)
        options = Options.new
        raw_options.each { |option| options.push Option.new(option) }
        options
      end
    end

  end
end