module Metro
  class Model

    class Property
      attr_reader :model, :options
      def initialize(model,options={})
        @model = model
        @options = options
      end
    end

  end
end

require_relative 'alpha'
require_relative 'color'
require_relative 'font_size'
require_relative 'font'
require_relative 'numeric'
require_relative 'multiplier'
require_relative 'string'
require_relative 'x_position'
require_relative 'y_position'
require_relative 'ratio'
require_relative 'image'