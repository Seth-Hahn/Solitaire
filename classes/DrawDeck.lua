--child class of CardHolder
--class inheritence based on code found at: https://stackoverflow.com/questions/65961478/how-to-mimic-simple-inheritance-with-base-and-child-class-constructors-in-lua-t

DrawDeck = {}
function DrawDeck:new(stack)
  DrawDeck.__index = DrawDeck
  setmetatable(DrawDeck, {__index = CardHolder})
  
  
  local drawDeck = CardHolder:new()
  setmetatable(drawDeck, DrawDeck)
  
  drawDeck.stack = stack
  return drawDeck
end

