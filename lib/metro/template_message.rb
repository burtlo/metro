class TemplateMessage

  def initialize(details = {})
    @messages = Array(details[:message]) + Array(details[:messages])
    @website = details[:website]
    @email = Array(details[:email])
  end

  attr_reader :messages

  def website
    "* #{@website}"
  end

  def email
    @email.map {|email| "* #{email}" }.join("\n")
  end

  def message_filename
    File.join(File.dirname(__FILE__),"..","templates","message.erb")
  end

  def message_template
    File.read(message_filename)
  end

  def to_s
    ERB.new(message_template).result(binding)
  end

end