--child class of CardHolder
--class inheritence based on code found at: https://stackoverflow.com/questions/65961478/how-to-mimic-simple-inheritance-with-base-and-child-class-constructors-in-lua-t

DrawDeck = {}
cardRankEnum = { --enum for rank values
  ACE = 1,
  TWO = 2, 
  THREE = 3,
  FOUR = 4,
  FIVE = 5, 
  SIX = 6,
  SEVEN = 7,
  EIGHT = 8,
  NINE = 9,
  TEN = 10,
  JACK = 11,
  QUEEN = 12,
  KING = 13,
}
function DrawDeck:new(xPos, yPos)
  DrawDeck.__index = DrawDeck
  setmetatable(DrawDeck, {__index = CardHolder})
  
  
  local drawDeck = CardHolder:new(xPos, yPos)
  setmetatable(drawDeck, DrawDeck)
  
  -- Create an Unshuffled Deck
  suits = { "c", "d", "s", "h" }  
  for suit = 1, 4, 1 do 
    for rank = cardRankEnum.ACE, cardRankEnum.KING, 1 do
      card = PlayingCard:new(suits[suit], rank, xPos, yPos)
      table.insert(drawDeck.cards, card)
      card.group = drawDeck.cards
    end
  end
  
  return drawDeck
end


-- Table shuffle based on code found at : https://stackoverflow.com/questions/35572435/how-do-you-do-the-fisher-yates-shuffle-in-lua
function DrawDeck:shuffleDeck()
  for i = #self.cards, 2, -1 do
    local j = math.random(i)
    self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
  end
end

function DrawDeck:drawToScreen()
  --for k, card in pairs(self.cards) do
  --love.graphics.draw(card.frontFace, card.x, card.y + (k * 20) )
  --end
  
  --create rectangle to show card holder position
  --love.graphics.setColor(0, 0, 0)
  --local holderGraphic = love.graphics.rectangle('line', self.x, self.y, cardWidth, cardHeight)
  --love.graphics.setColor(255,255,255)
  
  --draw down facing cards to represent the draw deck
  for k, card in pairs(self.cards) do
    love.graphics.draw(card.backFace, self.x * (k * .01) , self.y)
  end
  
  
end
