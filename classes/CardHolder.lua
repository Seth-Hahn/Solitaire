CardHolder = {}

cardHeight = 64
cardWidth = 42

function CardHolder:new(xPos, yPos)
  local cardHolder = {}
  
  setmetatable(cardHolder, {__index = CardHolder})
  
  cardHolder.x = xPos
  cardHolder.y = yPos
  cardHolder.cards = {}
  return cardHolder
end


function CardHolder:drawToScreen()
  --for k, v in pairs(self.cards) do
  -- love.graphics.draw(v.frontFace, 10 * k, 10 * k)
  --end
  
  --create rectangle to show card holder position
  love.graphics.setColor(0, 0, 0)
  local holderGraphic = love.graphics.rectangle('line', self.x, self.y, cardWidth, cardHeight)
  love.graphics.setColor(255,255,255)
  
end

