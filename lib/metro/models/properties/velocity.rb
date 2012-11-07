module Metro
  class Model

    class VectorProperty < Property
      
      def get(value)
        value ? value : Vector.new
      end
      
      def set(value)
        Vector.new value
      end
      
      class Vector
        
        def initialize(angle,velocity)
          @angle = angle
          @velocity = velocity
        end
        
        def decay!
          @velocity.decay!
        end
        
        def accelerate(amount,angle)
          
        end
        
        def apply_x(x_position)
          
        end
        
        def apply_y(y_position)
          
        end
        
        
      end
      
    end

    class VelocityProperty < Property

      def get(value)
        value ? value : Velocity.new(0.0,0.95)
      end

      def set(value)
        Velocity.new value
      end

      class Velocity

        def initialize(value,decay = default_decay)
          @value = value.to_f
          @decay = decay || default_decay
        end

        def default_decay
          0.95
        end

        def decay
          @value *= @decay
        end

        def accelerate(amount)
          @value += amount
        end

        def to_f
          @value
        end

      end

    end

  end
end