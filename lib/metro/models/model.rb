module Metro
  class Model

    attr_accessor :window, :scene

    def after_initialize ; end

    attr_reader :color

    def color=(value)
      @color = _convert_color(value)
    end

    def _convert_color(value)
      if value.is_a? Gosu::Color
        value
      elsif value.is_a? String
        value.to_i(16)
      else
        Gosu::Color.new(value)
      end
    end

    def alpha
      color.alpha
    end

    def alpha=(value)
      color.alpha = value.floor
    end

    def initialize(options = {})
      after_initialize
    end

    def _load(options = {})
      options = {} unless options
      @_loaded_options = []

      options.each do |raw_key,value|

        key = raw_key.dup
        key.gsub!(/-/,'_')
        key.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        key.gsub!(/([a-z\d])([A-Z])/,'\1_\2')

        @_loaded_options.push key

        unless respond_to? key
          self.class.send :define_method, key do
            instance_variable_get("@#{key}")
          end
        end

        unless respond_to? "#{key}="
          self.class.send :define_method, "#{key}=" do |value|
            instance_variable_set("@#{key}",value)
          end
        end

        send "#{key}=", value
      end

    end

    def _save
      data_export = @_loaded_options.map {|option| [ option, send(option) ] }.flatten
      Hash[*data_export]
    end

    #
    # Captures all classes that subclass Model.
    #
    # @see #self.scenes
    #
    def self.inherited(base)
      models << base
    end

    def self.model(name)
      @models_hash ||= begin

        hash = Hash.new(Models::Generic)

        models.each do |model|
          common_name = model.to_s.gsub(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
          common_name.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
          common_name.downcase!

          hash[common_name] = model
        end
        hash
      end

      @models_hash[name]
    end

    #
    # All subclasses of Model, this should be all the defined model within the game.
    #
    # @return an Array of Scene subclasses
    #
    def self.models
      @models ||= []
    end

  end
end

require_relative 'generic'
require_relative 'label'
require_relative 'select'
require_relative 'image'