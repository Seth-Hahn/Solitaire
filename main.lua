require "classes/Card"
require "classes/CardHolder"
require "classes/Stack"
require "classes/DrawDeck"
require "classes/CardColumn"


screenWidth, screenHeight = love.graphics.getDimensions()

function love.load()
  -- set green background
  background = love.graphics.newImage("assets/img/solitaireBackground.png")
  
  --seed random number generator for deck shuffle
  math.randomseed(os.time())
  --initialize and shuffle deck
  deck = DrawDeck:new(screenWidth / 30, screenHeight / 10)
  deck:shuffleDeck()
  
end

function love.draw()
  love.graphics.draw(background)
  deck:drawToScreen()
 

end
