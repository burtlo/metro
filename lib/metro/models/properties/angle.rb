module Metro
  class Model

    class AngleProperty < Property

      def get(value)
        value ? value : Angle.new(0.0, options[:step])
      end

      def set(value)
        Angle.new(value.to_f, options[:step])
      end

      class Angle

        attr_reader :value

        def initialize(value = 0.0,step = 1.0)
          @value = value.to_f
          @step = step || 1.0
        end

        def turn(direction)
          send(direction) if [ :left, :right ].include?(direction)
        end

        def left
          @value -= @step
        end

        def right
          @value += @step
        end

        def to_f
          @value.to_f
        end

      end

    end
  end
end