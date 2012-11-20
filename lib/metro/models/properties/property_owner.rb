module Metro

  module PropertyOwner

    def self.included(base)
      base.extend ClassMethods
    end

    #
    # The raw properties of the model. Most properties defined through the `property`
    # class method will have getters/setters that will do the appropriate translation
    # so this should in cases when you need access to the raw properties or there
    # is not a property accessors defined.
    #
    # @return [Hash] the raw properties of the model.
    #
    def properties
      @properties ||= {}
    end

    module ClassMethods

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
      def property(name,options={},&block)

        # Use the name as the property type if one has not been provided.

        property_type = options[:type] || name

        property_class = Model::Property.property(property_type)

        define_method name do
          raw_value = properties[name]

          unless parsed_value = instance_variable_get("@_property_parsed_#{name}")
            parsed_value = property_class.new(self,options,&block).get(raw_value)
            instance_variable_set("@_property_parsed_#{name}",parsed_value)
          end

          parsed_value
        end

        define_method "#{name}=" do |value|
          instance_variable_set("@_property_parsed_#{name}",nil)
          prepared_value = property_class.new(self,options).set(value)
          send("#{name}_changed",prepared_value) if respond_to? "#{name}_changed"
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
      def _sub_property(name,options={},&block)

        # Use the name as the property type if one has not been provided.

        property_type = options[:type] || name

        property_class = Model::Property.property(property_type)

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
    end

  end
end