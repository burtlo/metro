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
    # Define a property for the model. A property has a name and then can optionally specify
    # a property type which will receive additional options.
    #
    # @example Defining various propertys for a model
    #
    #     class Player
    #       property :position
    #       property :angle, default: 0.0
    #       property :turn_amount, default: 4.5
    #       property :image, path: "player.png"
    #       property :motto, type: :text, default: 'Hometown Heroes!'
    #     end
    #
    # When the property name matches a property definition with that name they will be used. This is what
    # happens for the 'position' and 'image' properties defined above. Both of those map to respective
    # properties with matching names.
    #
    # Properties by default are assumed to be numeric properties so the types does not have to be stated.
    # This is the case for 'angle' and 'turn_amount' properties.
    #
    # You may use any particular name for your properties as long as you specify the type. This is the case
    # for the 'motto' property.
    #
    def self.property(name,options={},&block)

      # Use the name as the property type if one has not been provided.

      property_type = options[:type] || name

      property_class = Property.property(property_type)

      define_method name do
        raw_value = properties[name]
        property_class.new(self,options,&block).get raw_value
      end

      define_method "#{name}=" do |value|
        prepared_value = property_class.new(self,options).set(value)
        properties[name] = prepared_value
      end

      # Define any sub-properties defined on this property

      # When the name does not match the property type then we want to force
      # the prefixing to be on for our sub-properties. This is to make sure
      # that when people define multiple fonts and colors that they do not
      # overlap.

      override_prefix = !(name == property_type)

      property_class.defined_properties.each do |subproperty|
        sub_options = { prefix: override_prefix }.merge(subproperty.options)
        sub_options = sub_options.merge(parents: (Array(sub_options[:parents]) + [name]))
        _sub_property subproperty.name, sub_options
      end

    end

    #
    # Defines the sub-properties defined within the property. This is to be used internally
    # by the #property method.
    #
    def self._sub_property(name,options={},&block)

      # Use the name as the property type if one has not been provided.

      property_type = options[:type] || name

      property_class = Property.property(property_type)

      parents = Array(options[:parents])

      method_name = name

      if options[:prefix]
        method_name = (parents + [name]).join("_")
      end

      # Define a getter for the sub-property that will traverse the
      # parent properties, finally returning the filtered value

      define_method method_name do
        raw_value = (parents + [name]).inject(self) {|current,method| current.send(method) }
        property_class.new(self,options).get raw_value
      end

      # Define a setter for the sub-property that will find the parent
      # value and set itself on that with the filtered value. The parent
      # is then set.
      #
      # @TODO: If getters return dups and not instances of the original object then a very
      #   deep setter will not be valid.
      #
      define_method "#{method_name}=" do |value|
        parent_value = parents.inject(self) {|current,method| current.send(method) }

        prepared_value = property_class.new(self,options,&block).set(value)
        parent_value.send("#{name}=",prepared_value)

        send("#{parents.last}=",parent_value)
      end
    end


    def properties
      @properties ||= {}
    end

    property :model, type: :text
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

      # Clean up and symbolize all the keys then merge  that with the existing properties
      options.keys.each do |key|
        options[key.to_s.underscore.to_sym] = options.delete(key)
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
      @models_hash ||= HashWithIndifferentAccess.new("Metro::Models::Generic")
    end

  end
end

require_relative 'models/generic'
require_relative 'models/label'
require_relative 'models/menu'
require_relative 'models/image'
require_relative 'models/rectangle'
require_relative 'models/grid_drawer'
