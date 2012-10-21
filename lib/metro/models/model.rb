module Metro

  #
  # The Model is a basic, generic representation of a game object
  # that has a visual representation within the scene's window.
  #
  # Model is designed to be an abstract class, to be subclassed by
  # other models.
  #
  # @see Models::Generic
  #
  class Model

    #
    # The window that this model that this window is currently being
    # displayed.
    #
    # The current value of window is managed by the scene
    # as this is set when the Scene is added to the window. All the
    # models gain access to the window.
    #
    # @see Window
    #
    attr_accessor :window

    #
    # The scene that this model is currently being displayed.
    #
    # The current value of scene is managed by the scene as this
    # is set when the scene is created.
    #
    # @see Scene
    attr_accessor :scene

    #
    # This is an entry point for customization. As the model's {#initialize}
    # method performs may perform some initialization that may be necessary.
    #
    # @note This method should be implemented in the Model subclass.
    #
    def after_initialize ; end

    #
    # Returns the color of the model. In most cases where color is a prominent
    # attribute (e.g. label) this will be the color. In the cases where color
    # is less promenint (e.g. image) this will likely be a color that can be
    # used to influence the drawing of it.
    #
    # @see #alpha
    #
    attr_reader :color

    #
    # Sets the color of the model.
    #
    # @param [String,Fixnum,Gosu::Color] value the new color to set.
    #
    def color=(value)
      @color = Gosu::Color.new(value)
    end

    #
    # @return the alpha value of the model's color. This is an integer value
    #   between 0 and 255.
    #
    def alpha
      color.alpha
    end

    #
    # Sets the alpha of the model.
    #
    # @param [String,Fixnum] value the new value of the alpha level for the model.
    #   This value should be between 0 and 255.
    #
    def alpha=(value)
      # TODO: coerce the value is between 0 and 255
      color.alpha = value.to_i
    end

    #
    # Create an instance of a model.
    #
    # @note Overridding initialize method should be avoided, using the {#aftter_initialize)
    # method or done with care to ensure that functionality is preserved.
    #
    def initialize(options = {})
      after_initialize
    end

    #
    # Loads a hash of content into the model. This process will convert the hash
    # of content into setter and getter methods with appropriate ruby style names.
    #
    # This is used internally when the model is created for the Scene. It is loaded
    # with the contents of the view.
    #
    def _load(options = {})
      options = {} unless options

      options.each do |raw_key,value|

        key = raw_key.dup
        key.gsub!(/-/,'_')
        key.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        key.gsub!(/([a-z\d])([A-Z])/,'\1_\2')

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

        _loaded_options.push key
        send "#{key}=", value
      end

    end

    def _loaded_options
      @_loaded_options ||= []
    end

    #
    # Generate a hash export of all the fields that were previously stored within
    # the model.
    #
    # This is used internally within the scene to transfer the data from one model
    # to another model.
    #
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

    #
    # All subclasses of Model, this should be all the defined model within the game.
    #
    # @return an Array of Scene subclasses
    #
    def self.models
      @models ||= []
    end

    #
    # Convert the specified model name into the class of the model.
    #
    # @return the Model class given the specified model name.
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

  end
end

require_relative 'generic'
require_relative 'label'
require_relative 'select'
require_relative 'image'