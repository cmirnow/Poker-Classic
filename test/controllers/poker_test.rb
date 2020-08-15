require 'test_helper'
class PokerControllerTest < ActionDispatch::IntegrationTest
  def test_to_string
    assert_equal('Card(suit:1, value:1)', Card.new(1, 1).inspect)
  end

  def test_simple_array_size
    cards = []
    cards << Card.new(1, 1)
    cards << Card.new(1, 2)
    cards << Card.new(1, 3)
    cards << Card.new(1, 1)
 
    assert_equal(4, cards.size)
    assert_equal(4, cards.uniq.size)
  end
 
  def test_comparable_array_size
    cards = []
    cards << CardComparable.new(1, 1)
    cards << CardComparable.new(1, 2)
    cards << CardComparable.new(1, 3)
    cards << CardComparable.new(1, 1)
 
    assert_equal(4, cards.size)
    assert_equal(3, cards.uniq.size)
  end
end 
