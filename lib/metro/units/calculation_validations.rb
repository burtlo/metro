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

    end
  end
end