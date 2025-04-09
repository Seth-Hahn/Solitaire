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
