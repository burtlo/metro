module Metro
  module Units
    module CalculationValidations

      #
      # @param [Object] value the other object that needs to be validated.
      #
      def check_calculation_requirements(value)
        if calculation_requirements.find { |method| ! value.respond_to?(method) }
          raise "Unable to perform operation with #{value} #{value.class} It is missing a property #{calculation_requirements.join(",")}"
        end
      end

      #
      # @return [Array] an array of methods that are required to be on the
      #   object for it to be correctly calculated.
      #
      # @note this method is intended to be defined in the including class. This
      #   method is included here when one has not been provided.
      def calculation_requirements
        []
      end

      #
      # Add this object to another object.
      #
      # @return a new object that is the sum of the two objects
      #
      def +(value)
        self.class.new *calculate(value,:+)
      end

      #
      # Subtract the other object from this object.
      #
      # @return a new object that is the difference of the original object
      #   and the value specified.
      #
      def -(value)
        self.class.new *calculate(value,:-)
      end

      #
      # Multiply this object and another object.
      #
      # @return a new object that is the product of the two objects.
      #
      def *(value)
        self.class.new *calculate(value,:*)
      end

      #
      # This generic method will perform the calculation defined by the
      # operation for all the calculation requirements defined.
      #
      # @param [value] value this is the other value that is being added,
      #   subtracted, etc. to the current object.
      # @param [Symbol] operation this is the mathematical operation that
      #   is being performed between all the calc requirements of the current
      #   object and other value.
      #
      # @return [Array] an array of reults from the calculations of all the
      #   requirements.
      #
      def calculate(value,operation)
        check_calculation_requirements(value)
        calculation_requirements.map do |requirement|
          send(requirement).send(operation,value.send(requirement))
        end
      end

    end
  end
end