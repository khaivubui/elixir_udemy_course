defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck makes 20 cards" do
    deck = Cards.create_deck
    assert length(deck) == 20
  end

  test "shuffle randomizes the order in a deck" do
    deck = Cards.create_deck
    assert deck != Cards.shuffle(deck) 
  end
end
