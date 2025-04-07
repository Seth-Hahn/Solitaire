require "classes/Card"
require "classes/CardHolder"
require "classes/Stack"
require "classes/DrawDeck"


function love.load()
  -- set green background
  background = love.graphics.newImage("assets/img/solitaireBackground.png")
  
  --seed random number generator for deck shuffle
  math.randomseed(os.time())
  --initialize and shuffle deck
  deck = createDeck()
  shuffleDeck(deck)
  
end

function love.draw()
  love.graphics.draw(background)
  
  for k, v in pairs(deck) do
    love.graphics.draw(v.frontFace, 10 * k, 10 * k)
  end 

end

function createDeck() 
  
  --initialize unshuffled deck
  unshuffledDeck = {}
  suits = { "c", "d", "s", "h" }
  ranks = { "2", "3", "4" , 
            "5", "6", "7",  
            "8", "9","10", 
            "J", "Q","K", "A" }
          
  for suit = 1, 4, 1 do 
    for rank = 1, 13, 1 do
      card = PlayingCard:new(suits[suit], ranks[rank])
      table.insert(unshuffledDeck, card)
    end
  end
  
  return unshuffledDeck
end



-- Table shuffle based on code found at : https://stackoverflow.com/questions/35572435/how-do-you-do-the-fisher-yates-shuffle-in-lua
function shuffleDeck(deck)
  for i = #deck, 2, -1 do
    local j = math.random(i)
    deck[i], deck[j] = deck[j], deck[i]
  end
end