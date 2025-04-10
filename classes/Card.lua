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
  playingCard.group = nil --reference to the group of cards the playing card currently belongs to
  return playingCard
end


--function PlayingCard:grab(
function PlayingCard:moveCardFromTo(newGroup)
  local isCardStack = false
  local tempCardHolder = {} --temporarily store cards being pulled in a stack to move from one table to another
  local cardStackPosition = #self.group --determines position of selected card within its current group
  
  for k, card in ipairs(self.group) do -- 1. search through the card's group and remove it from its position
    if self == card or isCardStack then
      
      if k ~= #self.group then -- 1b. pull any cards below the one being dragged (card stacks)
        isCardStack = true
        cardStackPosition = k 
      end
      
      table.insert(tempCardHolder, card) -- hold card(s) in temporary table to move between groups
    end
  end
  
  for i = #self.group, cardStackPosition, -1 do --reverse iterate through original group to maintain card order during removal
    table.remove(self.group, i)
  end
  
  for k, card in ipairs(tempCardHolder) do
    card.group = newGroup --switch each cards group reference to the new group
    table.insert(newGroup, card) --insert card into group
    card.x = newGroup[1].x
    card.y = newGroup[#newGroup].y 
  end 
  print('----------------------------------------------')
  for k, card in ipairs(self.group) do
    print(card.suit, card.rank)
  end
end