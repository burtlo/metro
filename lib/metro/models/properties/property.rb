module Metro
  class Model

    #
    # A property is a value filter that allows you to specify filtering options
    # both on the setting and the getting of a value. The property itself does
    # not maintain any of these values but keeps in mind the particular model
    # and options that it is created when applying the filtering.
    #
    # @note Property is intented to be subclassed to provide filtering of particular types.
    #
    class Property
      include Units

      attr_reader :model, :options, :block

      #
      # @param [Model] model the model associated with this property.
      # @param [Types] options the additional options that may be set with
      #   this property. This may be default values or options on how
      #   this properby should behave.
      #
      def initialize(model,options={},&block)
        @model = model
        @options = options
        @block = block
      end

      # Define a filter block for getting a value of that type.
      def self.get(*types,&block)
        types = [ NilClass ] if types.empty?
        types.each do |type|
          gets[type.to_s] = block
        end
      end

      # All get filter blocks defined
      def self.gets
        @gets ||= hash_with_default_to_nil
      end

      # Perform a get of the value, running it through the get
      # filter block that matches the type.
      def get(value)
        get_block = self.class.gets[value.class.to_s]
        instance_exec(value,&get_block)
      end

      # Define a filter block for setting a value of the type.
      def self.set(*types,&block)
        types = [ NilClass ] if types.empty?
        types.each do |type|
          sets[type.to_s] = block
        end
      end

      # All set filter blocks defined
      def self.sets
        @sets ||= hash_with_default_to_nil
      end

      # Perform a set of the value, running it through the set
      # filter block that matches the type.
      def set(value)
        set_block = self.class.sets[value.class.to_s]
        instance_exec(value,&set_block)
      end

      # Define a filter block that applies to both the setting and getting of a property.
      def self.get_or_set(type=NilClass,&block)
        gets[type.to_s] = block
        sets[type.to_s] = block
      end

      #
      # Allow a property to define a sub-property.
      #
      # A sub-property that is defined can be any type of exiting properties. Which
      # may also define more sub-properties. These sub-properties will be available as properties
      # through the names provided.
      #
      # @example DimensionProperty defining two numeric sub-properties for height and width
      #
      #     class DimensionsProperty < Property
      #       define_property :width
      #       define_property :height
      #     end
      #
      #     class Frogger < Metro::Model
      #       property :dimensions
      #
      #       def after_initialize
      #         puts "Frog dimensions are #{dimensions}"
      #         puts "(#{dimensions.width},#{dimensions.height}) == (#{width},#{height})"
      #       end
      #     end
      #
      # The sub-properties can also be prefixed with the parent property name:
      #
      # @example FontProperty defines sub-properties which include the parent propery prefix
      #
      #     class FontProperty < Property
      #       define_property :size, prefix: true
      #       define_property :name, type: :text, prefix: true
      #     end
      #
      #     class MyLabel < Metro::Model
      #       property :font
      #
      #       def after_initialize
      #         puts "Font is: #{font} - #{font_name}:#{font_size}"
      #       end
      #     end
      #
      # If you define a property with the non-default name it will automatically add the prefix
      # to all the sub-properties. This is to prevent any getter/setter method name collisions.
      #
      # @example DimensionProperty defining two numeric sub-properties for height and width
      #
      #     class DimensionsProperty < Property
      #       define_property :width
      #       define_property :height
      #     end
      #
      #     class Frogger < Metro::Model
      #       property :dims, type: :dimensions
      #
      #       def after_initialize
      #         puts "Frog dimensions are #{dims}"
      #         puts "(#{dims.width},#{dims.height}) == (#{dims_width},#{dims_height})"
      #       end
      #     end
      #
      def self.define_property(name,options = {})
        defined_properties.push PropertyDefinition.new name, options
      end

      #
      # @return an array of all the defined properties.
      #
      def self.defined_properties
        @defined_properties ||= []
      end

      #
      # Capture all the subclassed properties and add them to the availble list of
      # properties.
      #
      def self.inherited(subclass)
        property_name = subclass.to_s.gsub(/Property$/,'').split("::").last.underscore
        properties_hash[property_name] = subclass.to_s
      end

      def self.properties
        @properties ||= []
      end

      #
      # @return a Property Class that matches the specified name.
      #
      def self.property(name)
        property_classname = properties_hash[name]
        property_classname.constantize
      end

      #
      # Generate a properties hash. This properties will default to the numeric key when the property
      # type cannot be found.
      #
      def self.properties_hash
        @properties_hash ||= HashWithIndifferentAccess.new { |hash,key| hash[:numeric] }
      end

      #
      # Generate a hash that will default all missing keys to the NilClass key and the NilClass key will
      # return a cource of action that will raise an exception. This means by default that if it is not
      # overridden an error is generated.
      #
      def self.hash_with_default_to_nil
        hash = HashWithIndifferentAccess.new { |hash,key| hash["NilClass"] }
        hash["NilClass"] = lambda { |value| raise "#{self} is not able to translate the #{value} (#{value.class})" }
        hash
      end

    end

  end

  #
  # A property definition contains the name of the property and the options specified with it.
  # This is used internally to define properties and sub-properties.
  #
  class PropertyDefinition

    attr_reader :name, :options

    def initialize(name,options)
      @name = name
      @options = options
    end
  end

end

require_relative 'property_owner'

require_relative 'numeric_property'
require_relative 'text_property'
require_relative 'boolean_property'
require_relative 'array_property'
require_relative 'animation_property'
require_relative 'color_property'
require_relative 'dimensions_property'
require_relative 'font_property'
require_relative 'image_property'
require_relative 'position_property'
require_relative 'scale_property'
require_relative 'song_property'
require_relative 'sample_property'
require_relative 'options_property/options_property'