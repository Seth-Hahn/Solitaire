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


function CardHolder:drawToScreen(offset) --offset determines how spread out each card is from one another
  --for k, v in pairs(self.cards) do
  -- love.graphics.draw(v.frontFace, 10 * k, 10 * k)
  --end
  for k, card in pairs(self.cards) do
  if card.isFaceUp then
    love.graphics.draw(card.frontFace, card.x, card.y + (offset * k) )
  else 
    love.graphics.draw(card.backFace, card.x, card.y + (offset * k) )
  end
end

  

  --create rectangle to show card holder position if column is empty
  if #self.cards == 0 then
    love.graphics.setColor(0, 0, 0)
    local holderGraphic = love.graphics.rectangle('line', self.x, self.y, cardWidth, cardHeight)
    love.graphics.setColor(255,255,255)
  end 
  
end

