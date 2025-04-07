PlayingCard = {}


function PlayingCard:new(suit, rank)
  local playingCard = {}
  
  setmetatable(playingCard, {__index = PlayingCard})
  
  playingCard.suit = suit
  playingCard.rank = rank
  playingCard.frontFace = love.graphics.newImage("assets/img/Cards/" .. suit .. rank .. ".png")
  playingCard.backFace = love.graphics.newImage("assets/img/Cards/card_back.png")
  return playingCard
end

