class Symbol
  def to_attr
    Etter.new self
  end

  def to_setter
    Etter.setter self
  end

  def to_getter
    Etter.getter self
  end
end
