class Card
  attr_accessor :suit
  attr_accessor :value

  def initialize(suit = rand(1..4), value = rand(2..14))
    self.suit = suit
    self.value = value
  end

  def inspect
    "Card(suit:#{suit}, value:#{value})"
  end
end
