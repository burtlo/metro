class TemplateMessage

  def initialize(details = {})
    @messages = Array(details[:message]) + Array(details[:messages])
    @details = details[:details]
    @website = details[:website]
    @email = details[:contact]
  end

  class Message
    
    attr_reader :name, :details
    
    def initialize(name,details)
      @name = name
      @details = details
    end

    def field_locale(field)
      I18n.t("#{name}.#{field}",details)
    end

    def title
      field_locale 'title'
    end

    def message
      field_locale 'message'
    end

    def actions
      Array( field_locale('actions') ).map {|action| "* #{action}" }.join("\n")
    end
  end

  def messages
    @messages.map {|m| Message.new m, @details }
  end

  def website
    Array(@website).map {|website| "* #{website}" }.join("\n")
  end

  def email
    Array(@email).map {|email| "* #{email}" }.join("\n")
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