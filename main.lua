require "classes/Card"
require "classes/CardHolder"
require "classes/DrawDeck"
require "classes/CardColumn"
require "classes/AceHolder"

screenWidth, screenHeight = love.graphics.getDimensions()
UniversalCardSet = {} --used to access cards when moving them


function love.load()
  -- load green background
  background = love.graphics.newImage("assets/img/solitaireBackground.png")
  
  --seed random number generator for deck shuffle
  math.randomseed(os.time())
  
  
  --1. initialize and shuffle deck
  deck = DrawDeck:new(screenWidth / 40, screenHeight / 10)
  deck:shuffleDeck()
  for _, cards in ipairs(deck.cards) do
    table.insert(UniversalCardSet, cards) -- put cards into universal card set
  end
  
  --2. create the card columns
  cardColumnGroup = {} --group all the card columns into a larger group
  for i = 7, 1, -1 do
    table.insert(cardColumnGroup, CardColumn:new( (screenWidth / 1.25) - (i * 75), screenHeight / 10))
  end 
  
  --3. distribute draw deck into the card columns
  for i = 1, #cardColumnGroup, 1 do -- iterate through each card column
    for j = 1, i, 1 do -- fill card columns with corresponding number of cards
      local tempCard = table.remove(deck.cards) -- take top card of draw deck
      table.insert(cardColumnGroup[i].cards, tempCard) --insert into card column
      tempCard.x = cardColumnGroup[i].x --update card coordinates
      tempCard.y = cardColumnGroup[i].y + (j*20)
      tempCard.group = cardColumnGroup[i].cards
      if(i == j) then --last card in each column row should always be face up
        tempCard.isFaceUp = true
      end
    end
  end  
  
  --4. Initialize ace holding spots
  aceHolderGroup = {} --group the 4 aceholders together
  for i = 1, 4, 1 do
    table.insert(aceHolderGroup, AceHolder:new(screenWidth / 1.1, (screenHeight) - (75 * i) ) )    
  end
end

function love.draw()
  love.graphics.draw(background)
  deck:drawToScreen()
  
  for i = 1, #cardColumnGroup, 1 do
    cardColumnGroup[i]:drawToScreen(0)
  end 
  
  for i = 1, #aceHolderGroup, 1 do
    aceHolderGroup[i]:drawToScreen(0)
  end
end




-------Player Controls----------

selectedCard = nil --holds card selected by mouse press
isDragging = false --determines when cards are being dragged on screen

function love.mousepressed(mx, my, button)
  if button == 1 then
    selectedCard = nil --deselects if nothing is clicked
    
    for _, card in ipairs(UniversalCardSet) do
        if clickOnCard(mx, my, card) then
          selectedCard = card --hold the card which was clicked
          isDragging = true --allow card to be dragged
          return
        end
  
    end
        
  end
end

function love.mousemoved(mx, my) --drag cards along with mouse
  if isDragging and selectedCard and selectedCard.isFaceUp then
    selectedCard.x = mx
    selectedCard.y = my
  end
end

function love.mousereleased(mx, my, button)
  if button == 1 and selectedCard.isFaceUp then
    
    for _, card in ipairs(UniversalCardSet) do --iterate through every card 
      if clickOnCard(mx, my, card)  then --check if the held card is released on top of another card
          selectedCard:moveCardFromTo(card.group)
      end
    end
          
    isDragging = false
    selectedCard = nil
    
  end 
end


 
 
 function clickOnCard(mx, my, card)
   return mx >= card.x and mx <= card.x + card.width and
          my >= card.y and my <= card.y + card.height 
 end
