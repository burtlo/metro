module Metro
  class Model
    
    class StringProperty < Property
      def get(value)
        model.scene.instance_eval( "\"#{value}\"" )
      end

      def set(value)
        value.to_s
      end
    end

  end
end