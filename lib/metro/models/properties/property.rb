module Metro
  class Model

    class Property
      include Units
      
      attr_reader :model, :options

      def initialize(model,options={})
        @model = model
        @options = options
      end

      def self.gets
        @gets ||= begin
          hash = HashWithIndifferentAccess.new { |hash,key| hash["NilClass"] }
          hash["NilClass"] = lambda { |value| raise "#{self} is not able to translate the #{value} (#{value.class})" }
          hash
        end
      end

      def self.get(type=NilClass,&block)
        gets[type.to_s] = block
      end

      def get(value)
        get_block = self.class.gets[value.class.to_s]
        instance_exec(value,&get_block)
      end

      def self.sets
        @sets ||= begin
          hash = HashWithIndifferentAccess.new { |hash,key| hash["NilClass"] }
          hash["NilClass"] = lambda { |value| raise "#{self} is not able to translate the #{value} (#{value.class})" }
          hash
        end
      end

      def self.set(type=NilClass,&block)
        sets[type.to_s] = block
      end

      def set(value)
        set_block = self.class.sets[value.class.to_s]
        instance_exec(value,&set_block)
      end

      def self.get_or_set(type=NilClass,&block)
        gets[type.to_s] = block
        sets[type.to_s] = block
      end

      def self.defined_properties
        @defined_properties ||= []
      end

      def self.define_property(name,options = {})
        defined_properties.push PropertyDefinition.new name, options
      end

      def self.inherited(subclass)
        properties << subclass
      end

      def self.properties
        @properties ||= []
      end

      def self.property(name)
        property_classname = properties_hash[name]
        property_classname.constantize
      end

      def self.properties_hash
        @properties_hash ||= begin
          hash = ActiveSupport::HashWithIndifferentAccess.new("Metro::Model::NumericProperty")
          properties.each do |prop|
            prop_name = prop.to_s.gsub(/Property$/,'').split("::").last.underscore
            hash[prop_name] = prop.to_s
          end
          hash
        end
      end

    end

  end

  class PropertyDefinition

    attr_reader :name, :options

    def initialize(name,options)
      @name = name
      @options = options
    end
  end

end

require_relative 'angle'
require_relative 'animation'
require_relative 'color'
require_relative 'dimensions'
require_relative 'font'
require_relative 'image'
require_relative 'numeric'
require_relative 'position'
require_relative 'scale'
require_relative 'text'
require_relative 'velocity'