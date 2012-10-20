module Metro
  class Generic

    attr_accessor :window

    def initialize(options = {})
      options.each do |raw_key,value|

        key = raw_key.dup
        key.gsub!(/-/,'_')
        key.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        key.gsub!(/([a-z\d])([A-Z])/,'\1_\2')

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

        send "#{key}=", value
      end
    end

  end
end
