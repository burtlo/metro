class String

  def snake_case
    snaked_string = self.gsub(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    snaked_string.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    snaked_string.downcase
  end

  def camel_case
    camel_string = self.to_s.gsub(/Scene$/i,'')
    camel_string = camel_string.sub(/^[a-z\d]*/) { $&.capitalize }
    camel_string = camel_string.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
  end

end