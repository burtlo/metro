module Metro
  module Parameters

    #
    # Options are the result of a parameters parser. The options class defines
    # a read-only structure that provides getters for all the parameters
    # specified within the has.
    #
    # @see CommandLineArgsParser
    #
    class Options
      def initialize(params = {})
        params.each do |key,value|
          self.class.send(:define_method,key) { value }
          self.class.send(:define_method,"#{key}?") { value }
        end
      end
      
      def method_missing(name,*args,&block)
        return false
      end
    end

  end
end