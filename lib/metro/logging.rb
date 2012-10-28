
#
# Generates a default logger to standard out that can be used within Metro or the game.
# 
# @example Outputting information at the debug level
# 
#     log.debug "The the screen resolution is #{Game.width},#{Game.height}"
# 
def log
  @log ||= begin
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    logger
  end
end

#
# Display an error message defined within the localization file. A game error displays
# a error title, message, and actions that can be taken to possibly address this issue.
# 
# @param [String] message the I18n string found in the locale file.
# @param [Hash] details contains all the possible key-value pairs that might be needed
#  for the localized error messages.
# 
def error!(messages, details = {})
  details = { show: true }.merge details

  message = TemplateMessage.new messages: messages, details: details,
    website: Game.website, contact: Game.contact

  warn message if details[:show]
  exit 1
end
