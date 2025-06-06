require "classes/Card"
require "classes/CardHolder"
require "classes/DrawDeck"
require "classes/CardColumn"
require "classes/AceHolder"

screenWidth, screenHeight = love.graphics.getDimensions()
UniversalCardSet = {} --used to access cards when moving them
cardRankEnum = { --enum for rank values
  ACE = 1,
  TWO = 2, 
  THREE = 3,
  FOUR = 4,
  FIVE = 5, 
  SIX = 6,
  SEVEN = 7,
  EIGHT = 8,
  NINE = 9,
  TEN = 10,
  JACK = 11,
  QUEEN = 12,
  KING = 13,
}

resetButton = {
  x = screenWidth / 10,
  y = screenHeight - 80,
  width = 80,
  height = 40
}

gameWon = false
-----------------------love functions----------------------------------------------
function love.load()
  gameWon = false
  -- load green background
  background = love.graphics.newImage("assets/img/solitaireBackground.png")
  
  --seed random number generator for deck shuffle
  math.randomseed(os.time())
  math.random() math.random() math.random() --shuffle the randomizer a few times
  
  
  --1. initialize and shuffle deck
  deck = DrawDeck:new(screenWidth / 40, screenHeight / 10)
  deck:shuffleDeck()
  for _, cards in ipairs(deck.cards) do
    table.insert(UniversalCardSet, cards) -- put cards into universal card set
  end
  
  --2. create the card columns
  cardColumnGroup = {} --group all the card columns into a larger group
  for i = 7, 1, -1 do
    table.insert(cardColumnGroup, CardColumn:new( (screenWidth / 1.25) - (i * 75), screenHeight / 500) )
  end 
  
  --3. distribute draw deck into the card columns
  for i = 1, #cardColumnGroup, 1 do -- iterate through each card column
    for j = 1, i, 1 do -- fill card columns with corresponding number of cards
      local tempCard = table.remove(deck.cards) -- take top card of draw deck
      table.insert(cardColumnGroup[i].cards, tempCard) --insert into card column
      tempCard.x = cardColumnGroup[i].x --update card coordinates
      tempCard.y = cardColumnGroup[i].y + (j*20)
      tempCard.group = cardColumnGroup[i].cards
      tempCard.inDrawDeck = false
      if(i == j) then --last card in each column row should always be face up
        tempCard.isFaceUp = true
      end
    end
  end  
  
  --4. Initialize ace holding spots
  aceHolderGroup = {} --group the 4 aceholders together
  for i = 1, 4, 1 do
    table.insert(aceHolderGroup, AceHolder:new(screenWidth / 1.1, (screenHeight) - (75 * i)) )    
  end
end

function love.draw()
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(background)
  deck:drawToScreen(selectedCard)
  
  for i = 1, #cardColumnGroup, 1 do
    cardColumnGroup[i]:drawToScreen(20)
  end 
  
  for i = 1, #aceHolderGroup, 1 do
    aceHolderGroup[i]:drawToScreen(0)
  end
  
  if gameWon then
    love.graphics.print("You Win!", screenWidth / 2, screenHeight / 2)
  end
  
  love.graphics.setColor(256,256,256)
  love.graphics.rectangle("fill", resetButton.x, resetButton.y, resetButton.width, resetButton.height)
  love.graphics.setColor(0,0,0)
  resetText = love.graphics.print("RESET", screenWidth / 8, screenHeight - 70)
  
  
  
end

function love.update()
  if isMouseDown == false then
    for _, cardColumn in ipairs(cardColumnGroup) do
      for k, card in ipairs(cardColumn.cards) do 
        card.x = cardColumn.x
        card.y = cardColumn.y + (40 * k)
      end
    end
    
    numCompletedAceHolders = 0
    for _, AceHolder in ipairs(aceHolderGroup) do
      for k, card in ipairs(AceHolder.cards) do
        card.x = AceHolder.x
        card.y = AceHolder.y
        if k == cardRankEnum.KING then
          numCompletedAceHolders = numCompletedAceHolders + 1
        end
      end
    end
    
    if numCompletedAceHolders == 4 then
      gameWon = true
    end
  end
end




-------Player Controls----------

selectedCard = nil --holds card selected by mouse press
isDragging = false --determines when cards are being dragged on screen
isMouseDown = false

function love.mousepressed(mx, my, button)
  if button == 1 then
    isMouseDown = true
    selectedCard = nil --deselects if nothing is clicked
    
    if clickOnCard(mx, my, deck) then --draw 3 (or less) cards from draw deck
      deck:pullCards()
    end 
    
    if clickOnCard(mx, my, resetButton) then
      love.load()
      return 
    end
    
    for i = #UniversalCardSet, 1, -1 do --check each card to see if it was clicked
      local card = UniversalCardSet[i]
        if clickOnCard(mx, my, card) then
          for k, drawPileCard in ipairs(deck.drawPile) do --check if clicked card was in draw pile
            if k ~= #deck.drawPile and card == drawPileCard then --if clicked card was in draw pile, it must be the top card to be valid
              --return 
            end
          end
          selectedCard = card --hold the card which was clicked
          isDragging = true --allow card to be dragged
          return
        end  
    end
  end
end

function love.mousemoved(mx, my) --drag cards along with mouse
  local tempCardStack = {}
  local isCardStack = false
  if isDragging and selectedCard and selectedCard.isFaceUp then
    selectedCard.x = mx
    selectedCard.y = my
    for k, card in ipairs(selectedCard.group) do -- drag a stack of face up cards
      if k ~= #selectedCard.group and selectedCard == card then
          isCardStack = true
      end
      
      if selectedCard ~= card and isCardStack then --update coordinates of cards below the selected (dragged) card
        card.x = mx
        card.y = my + (5 * k - 1)
      end
    end
  end
end

function love.mousereleased(mx, my, button)
  if button == 1 then
    isMouseDown = false
  end
    if selectedCard and  selectedCard.isFaceUp then
      
      for _, cardColumn in ipairs(cardColumnGroup) do --iterate through the card columns to determine if card is placed in one 
        
        if clickOnCard(mx, my, cardColumn) then -- allows for kings to be placed in empty columns
          if selectedCard.rank == cardRankEnum.KING then
            selectedCard:moveCardFromTo(cardColumn.cards)
          end
          
        end
        for _, card in ipairs(cardColumn.cards) do -- check each card in each column to determine if placement is valid
          if clickOnCard(mx, my, card) and card.isFaceUp then
            if(checkValidCardPlacement(selectedCard, card, 'CardColumn')) then
                selectedCard:moveCardFromTo(card.group)
            end
          end
        end
      end
      
      
      for _, AceHolder in ipairs(aceHolderGroup) do --check each aceholder to determine if card is being placed there
        if( clickOnCard(mx, my, AceHolder) )  --if the mouse is released over the aceholder
          and checkValidCardPlacement(selectedCard, AceHolder, 'AceHolder') then
            selectedCard:moveCardFromTo(AceHolder.cards)
            selectedCard.inAceHolder = true
            selectedCard.correspondingAceHolder = AceHolder
        end
      end
      isDragging = false
      selectedCard = nil
  end
end

function checkValidCardPlacement(cardToPlace, destCard, destinationType)
  if destinationType == 'CardColumn' then
    if (cardToPlace.suit == 's' or cardToPlace.suit == 'c')  --diamnonds and hearts can only be placed on spades or clubs
    and (destCard.suit == 'd' or destCard.suit == 'h') then
      
      if cardToPlace.rank + 1 == destCard.rank then --cards placed within columns must be one value lower than the current top card
        return true
      end
    end
    if (cardToPlace.suit == 'd' or cardToPlace.suit == 'h')  --clubs and spades can only be placed on hearts or clubs
    and (destCard.suit == 'c' or destCard.suit == 's') then
      
      if cardToPlace.rank + 1 == destCard.rank then --cards placed within columns must be one value lower than the current top card
        return true
      end
    end
  end
  
  if destinationType == 'AceHolder' then
    if destCard.currentValue == 0 and cardToPlace.rank == 1 then --aceholder is empty and card being placed is an ace
      destCard.suit = cardToPlace.suit --aceholder now only holds this suit
      destCard.currentValue = destCard.currentValue + 1
      return true
    elseif cardToPlace.rank == destCard.currentValue + 1 
    and cardToPlace.suit == destCard.suit then
      destCard.currentValue = destCard.currentValue + 1
      return true
    end
  end

return false
end

 
 function clickOnCard(mx, my, card)
   return mx >= card.x and mx <= card.x + card.width and
          my >= card.y and my <= card.y + card.height 
 end
