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
  
  drawDeck.drawPile = {}
  drawDeck.discardPile = {}
  return drawDeck
end


-- Table shuffle based on code found at : https://stackoverflow.com/questions/35572435/how-do-you-do-the-fisher-yates-shuffle-in-lua
function DrawDeck:shuffleDeck()
  for i = #self.cards, 2, -1 do
    local j = math.random(i)
    self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
  end
end

function DrawDeck:drawToScreen(heldCard)
  --create rectangle to show card holder position if column is empty
  if #self.cards == 0 then
    love.graphics.setColor(0, 0, 0)
    local deckHolderGraphic = love.graphics.rectangle('line', self.x, self.y, cardWidth, cardHeight)
    love.graphics.setColor(255,255,255)
  else 
    --draw down facing cards to represent the draw deck
    for k, card in pairs(self.cards) do
      love.graphics.draw(card.backFace, self.x * (k * .01) , self.y)
      card.x = self.x
      card.y = self.y
    end
  end
  
   --create rectangle to show card holder position if column is empty
  if #self.drawPile == 0 then
    love.graphics.setColor(0, 0, 0)
    local drawPileHolderGraphic = love.graphics.rectangle('line', self.x, self.y + 125, cardWidth, cardHeight)
    love.graphics.setColor(255,255,255)
  else 
    for i = 1, #self.drawPile, 1 do
      if self.drawPile[i] ~= heldCard then
        self.drawPile[i].x = self.x
        self.drawPile[i].y = self.y + (60 * i)
      end
        love.graphics.draw(self.drawPile[i].frontFace, self.drawPile[i].x, self.drawPile[i].y)
    end
  end
  

  
  
end

function DrawDeck:pullCards() 
  numCardsToDraw = math.min(#self.cards, 3) -- pull max of 3 cards or less if there are fewer cards left in the deck
  
  
  if  #self.cards == 0 then --if draw deck is empty redistribute discard pile into draw deck
    self:redistributeCards(self.drawPile, self.discardPile, #self.drawPile, false) --empty drawpile before cleaning discard
    self:redistributeCards(self.discardPile, self.cards, #self.discardPile, false)
  elseif #self.drawPile ~= 0 then --remove current draw pile cards into discard pile
    self:redistributeCards(self.drawPile, self.discardPile, #self.drawPile, false)
  end
    
  self:redistributeCards(self.cards, self.drawPile, numCardsToDraw, true) --draw cards into draw pile
end

function DrawDeck:redistributeCards(moveFrom, moveTo, numIterations, isFaceUp)
    for i = 1, numIterations, 1 do
      local cardToRedistribute = table.remove(moveFrom, 1)
      cardToRedistribute.isFaceUp = isFaceUp
      table.insert(moveTo, cardToRedistribute)
      cardToRedistribute.group = moveTo
    end
end