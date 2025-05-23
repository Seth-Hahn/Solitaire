PlayingCard = {}
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

function PlayingCard:new(suit, rank, xPos, yPos)
  local playingCard = {}
  
  setmetatable(playingCard, {__index = PlayingCard})
  
  playingCard.suit = suit
  playingCard.rank = rank
  playingCard.frontFace = love.graphics.newImage("assets/img/Cards/" .. suit .. rank .. ".png")
  playingCard.backFace = love.graphics.newImage("assets/img/Cards/card_back.png")
  playingCard.x = xPos
  playingCard.y = yPos
  playingCard.width = playingCard.frontFace:getWidth()
  playingCard.height = playingCard.frontFace:getHeight()
  playingCard.isFaceUp = false
  playingCard.group = nil --reference to the group of cards the playing card currently belongs to
  playingCard.inDrawDeck = nil
  playingCard.inAceHolder = false
  playingCard.correspondingAceHolder = nil
  return playingCard
end


function PlayingCard:moveCardFromTo(newGroup)
  if newGroup == self.group then --1. set cards back in their original spot if placement is invalid / placed back on their group
    return 
  end

  local cardIndex = 0 --2.  find the index of the card within its current group
  for k, card in ipairs(self.group) do
    if card == self then
      cardIndex = k
      break
    end
  end
  
  if self.inDrawDeck == true or self.inAceHolder then -- cards from the draw pile should have their own logic
    if self.inAceHolder and self.correspondingAceHolder then
      self.correspondingAceHolder.currentValue = self.correspondingAceHolder.currentValue - 1
      self.correspondingAceHolder = nil
    end
    table.remove(self.group, cardIndex)
    table.insert(newGroup, self)
    self.group = newGroup
    return
  end
  
  local tempCardHolder = {} --3. store all the cards that need to be moved
  for i = cardIndex, #self.group do
    table.insert(tempCardHolder, self.group[i])
  end
  
  for i = #self.group, cardIndex, -1 do --4. remove card(s) from their original group
    table.remove(self.group, i)
  end
  
  for _, card in ipairs(tempCardHolder) do --5. add cards to new group
    card.group = newGroup
    table.insert(newGroup, card)
  end
end