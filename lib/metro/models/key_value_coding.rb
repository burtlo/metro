module Metro

  #
  # Key-Value coding emulates the functionality found in Objective-C, which allows
  # for an object to be sent a message which contains the method to return. This is
  # the same as Ruby. However, Objective-C also supports the use of the dot notation
  # within the keys to acces the sub-values.
  #
  # @example Setting the red value of the color on a Model.
  #
  #     class Elf
  #       include KeyValueCoding
  #
  #       attr_accessor :color
  #     end
  #
  #     elf = Elf.new
  #     elf.color = Gosu::Color.new "rgb(0,0,0)"
  #
  #     elf.get("color.red")      # => 0
  #     elf.set("color.red",255)
  #     elf.get("color.red")      # => 255
  #
  module KeyValueCoding

    def set(name,value)
      keys = name.to_s.split('.')
      key_to_set = keys[0..-2].inject(self) {|target,method| target.send(method) }
      key_to_set.send("#{keys.last}=",value)
    end

    def get(name)
      keys = name.to_s.split('.')
      keys.inject(self) {|target,method| target.send(method) }
    end
  end

end