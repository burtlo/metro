require_relative 'key_value_coding'
require_relative 'rectangle_bounds'
require_relative 'properties/property'

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
    # This is called every update interval while the actor is in the scene
    #
    # @note This method should be implemented in the Model subclass
    #
    def update ; end

    #
    # This is called after an update. A model normally is not removed after
    # an update, however if the model responds true to #completed? then it
    # will be removed.
    # 
    # @note This method should be implemented in the Model sublclass if you
    #   are interested in having the model be removed from the scene.
    # 
    def completed? ; false ; end

    def self.property(name,property_type)
      define_method name do
        property_type.new(self).get properties[name]
      end

      define_method "#{name}=" do |value|
        puts "#{name}=#{value}" if name == :padding
        properties[name] = property_type.new(self).set(value)
      end
    end

    def properties
      @properties ||= {}
    end

    #
    # This is called after every {#update} and when the OS wants the window to
    # repaint itself.
    #
    # @note This method should be implemented in the Model subclass.
    #
    def draw ; end
    
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

    include KeyValueCoding

    #
    # This is an entry point for customization. As the model's {#initialize}
    # method performs may perform some initialization that may be necessary.
    #
    # @note This method should be implemented in the Model subclass.
    #
    def after_initialize ; end

    #
    # Generate a custom notification event with the given name.
    #
    # @param [Symbol] event the name of the notification to generate.
    #
    def notification(event)
      scene.notification(event.to_sym,self)
    end

    #
    # Allows for the definition of events within the scene.
    #
    include HasEvents

    def saveable?
      true
    end

    # Belongs to positionable items only
    def contains?(x,y)
      false
    end

    # Belongs to positionable items only
    def offset(x,y)
      self.x += x
      self.y += y
    end

    #
    # Create an instance of a model.
    #
    # @note Overridding initialize method should be avoided, using the {#aftter_initialize)
    # method or done with care to ensure that functionality is preserved.
    #
    def initialize(options = {})
      _load(options)
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

        key = raw_key.to_s.dup
        key = key.gsub(/-/,'_').underscore

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
      data_export = _loaded_options.map {|option| [ option, send(option) ] }.flatten
      Hash[*data_export]
    end

    #
    # Generate a hash representation of the model. Currently this is ugly
    #
    def to_hash
      export = _loaded_options.map {|option| [ option, send(option) ] }
      export_with_name = export.reject {|item| item.first == "name" }

      hash = export_with_name.inject({}) {|hash,elem| hash[elem.first] = elem.last ; hash }

      # TODO:: color is a class that cannot be yamlized as it is and needs to be turned into a string.
      # TODO: Hack to save the Gosu::Color class as a string value (this is
      # what I hoped that the properties would solve)
      hash.each do |subkey,subvalue|
        if subvalue.is_a? Gosu::Color
          hash[subkey] = subvalue.to_s
        end
      end

      { name => hash }
    end

    #
    # @return a common name that can be used through the system as a common identifier.
    #
    def self.metro_name
      name.underscore
    end

    #
    # @return an array of all ancestor models by name
    #
    def self.hierarchy
      ancestors.find_all {|a| a.respond_to? :metro_name }.map(&:metro_name)
    end

    #
    # Captures all classes that subclass Model.
    #
    # @see #self.scenes
    #
    def self.inherited(base)
      models << base.to_s
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

        hash = Hash.new("Metro::Models::Generic")

        models.each do |model|
          common_name = model.to_s.underscore
          hash[model.to_s] = model
          hash[model.downcase] = model
          hash[common_name] = model
        end

        hash
      end

      @models_hash[name]
    end

  end
end

require_relative 'models/generic'
require_relative 'models/label'
require_relative 'models/menu'
require_relative 'models/image'
require_relative 'models/rectangle'
require_relative 'grid_drawer'