class Error

  def initialize(details = {})
    @title = details[:title]
    @message = details[:message]
    @details = details[:details]
  end

  def title
    "ERROR: #{@title.upcase}"
  end

  def message
    @message
  end

  def details
    @details.map {|detail| "* #{detail}" }.join("\n")
  end

end