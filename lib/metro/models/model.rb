require_relative 'key_value_coding'
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
    include PropertyOwner
    include Units

    #
    # This is an entry point for customization. As the model's {#initialize}
    # method performs may perform some initialization that may be necessary.
    #
    # At this point the model has been created. However, the window and scene
    # of the model will not have been defined and defined properties rely on
    # the window or scene will return nil values. Other properties also will
    # likely not be set.
    #
    # @note This method should be implemented in the Model subclass.
    #
    def after_initialize ; end

    #
    # This is an entry point for customization. After the model's properties
    # have been set and the model has been assigned to the window and scene
    # this method is called. Here is where customization of properties or
    # final positioning can be performed.
    #
    # @note This method may be implemented in the Model subclass.
    #
    def show ; end

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

    #
    # This is called after every {#update} and when the OS wants the window to
    # repaint itself.
    #
    # @note This method should be implemented in the Model subclass.
    #
    def draw ; end

    #
    # @return [String] the name of the model class.
    #
    property :model, type: :text

    #
    # @return [String] the name of model as it is used within the view or the scene.
    #   This is the common name, the key within the view file, or the name symbol
    #   name specified in the scene.
    #
    property :name, type: :text

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

    #
    # A helper method that allows the current model to generate another model. This
    # is useful as it allows for the current model to pass window and scene state
    # to the created model.
    #
    # @param [String] model_name the name of the model to be created.
    # @return [Metro::Model] the metro model instance
    #
    def create(model_name,options={})
      # @TODO: this is another path that parallels the ModelFactory
      model_class = Metro::Model.model(model_name).constantize
      mc = model_class.new options
      mc.scene = scene
      mc.window = window
      mc
    end

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
      # Clean up and symbolize all the keys then merge that with the existing properties
      options.keys.each do |key|
        property_name = key.to_s.underscore.to_sym
        if respond_to? "#{property_name}="
          send("#{property_name}=",options.delete(key))
        else
          options[property_name] = options.delete(key)
        end
      end

      properties.merge! options
    end

    #
    # Generate a hash export of all the fields that were previously stored within
    # the model.
    #
    # This is used internally within the scene to transfer the data from one model
    # to another model.
    #
    def _save
      properties
    end

    #
    # Generate a hash representation of the model.
    #
    def to_hash
      { name => properties.except(:name) }
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
    # @see #self.models_hash
    #
    def self.inherited(model)
      models_hash[model.to_s] = model.to_s
      models_hash[model.to_s.downcase] = model.to_s
      models_hash[model.to_s.underscore] = model.to_s
    end

    #
    # Convert the specified model name into the class of the model.
    #
    # @return the Model class given the specified model name.
    def self.model(name)
      models_hash[name]
    end

    def self.models_hash
      @models_hash ||= HashWithIndifferentAccess.new("Metro::UI::Generic")
    end

  end
end

require_relative 'ui/generic'
require_relative 'ui/label'
require_relative 'ui/menu'
require_relative 'ui/image'
require_relative 'ui/rectangle'
require_relative 'ui/grid_drawer'
require_relative 'audio/song'
