--child class of CardHolder
--Handles the 4 ace holding spots
--class inheritence based on code found at: https://stackoverflow.com/questions/65961478/how-to-mimic-simple-inheritance-with-base-and-child-class-constructors-in-lua-t

AceHolder = {}
function AceHolder:new(xPos, yPos)
  AceHolder.__index = AceHolder
  setmetatable(AceHolder, {__index = CardHolder})
  
  
  local  aceHolder = CardHolder:new(xPos, yPos)
  setmetatable(aceHolder, AceHolder)
  aceHolder.currentValue = 0
  aceHolder.suit = nil
  
  return aceHolder
end