
class Class

  #
  # Within Metro often times a Class or the name of the class is being used.
  # ActiveSupport provides the constantize on Strings and Symbols but does
  # not provide it on Class. So instead of providing redundant checks in
  # places this monkeypatch simply makes Classes adhere to the same interface.
  #
  # @return [Class] itself.
  def constantize
    self
  end
end