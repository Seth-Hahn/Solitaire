PlayingCard = {}


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
  playingCard.group = nil --determines where the playing card is
  return playingCard
end


--function PlayingCard:grab(
function PlayingCard:moveCardFromTo(newGroup)
  for k, card in ipairs(self.group) do --search through the card's group and remove it from its position
    if self == card then
      table.remove(self.group, k)
    end
  end
  
  self.group = newGroup --switch card's group reference to new group
  table.insert(newGroup, self)
  
  --update card coordinates to new position
  self.x = newGroup[1].x
  self.y = newGroup[#newGroup].y  
end