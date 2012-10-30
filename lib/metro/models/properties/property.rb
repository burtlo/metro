module Metro
  class Model

    class Property
      attr_reader :model, :options

      def initialize(model,options={})
        @model = model
        @options = options
      end

      def self.inherited(subclass)
        properties << subclass
      end

      def self.properties
        @properties ||= []
      end

      def self.property(name)
        properties_hash[name]
      end

      def self.properties_hash
        @properties_hash ||= begin
          hash = Hash.new(NumericProperty)
          properties.each do |prop|
            hash[prop] = prop
            prop_name = prop.to_s.gsub(/Property$/,'').split("::").last.snake_case
            hash[prop_name] = prop
            hash[prop_name.to_sym] = prop
          end
          hash
        end
      end

    end

  end
end

require_relative 'alpha'
require_relative 'color'
require_relative 'font_size'
require_relative 'font'
require_relative 'numeric'
require_relative 'multiplier'
require_relative 'text'
require_relative 'x_position'
require_relative 'y_position'
require_relative 'ratio'
require_relative 'image'
require_relative 'angle'
require_relative 'velocity'