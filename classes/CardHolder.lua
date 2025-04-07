CardHolder = {}


function CardHolder:new()
  local cardHolder = {}
  
  setmetatable(cardHolder, {__index = CardHolder})
  
  return cardHolder
end

