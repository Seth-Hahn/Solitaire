--child class of CardHolder
--Handles the playing card columns
--class inheritence based on code found at: https://stackoverflow.com/questions/65961478/how-to-mimic-simple-inheritance-with-base-and-child-class-constructors-in-lua-t

CardColumn = {}
function CardColumn:new(xPos, yPos)
  CardColumn.__index = CardColumn
  setmetatable(CardColumn, {__index = CardHolder})
  
  
  local cardColumn = CardHolder:new(xPos, yPos)
  setmetatable(cardColumn, CardColumn)

  
  return cardColumn
end