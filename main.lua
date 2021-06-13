
function newButton(text, fn)
  return {
    text = text,
    fn = fn,
    now = false,
    last = false,
    x = 0,
    y = 0
  }
end

local menuButtons = {}
local levelButtons = {}

local creditsVel = 100

function love.load()
  -- love.graphics.setBackgroundColor(0.5, 0.5, 0.5, 1) -- for debugging
  Object = require "classic"
  require "player"
  require "levels"
  love.graphics.setDefaultFilter('nearest', 'nearest')

  logo = love.graphics.newImage("magnetvox.png")
  esc = love.graphics.newImage("Esc.png")


  menuFont = love.graphics.newFont("Mick Caster.ttf", 40)
  selectionFont = love.graphics.newFont("BD-TinyFont.otf", 20)
  creditsFont = love.graphics.newFont("Order-Regular.ttf", 20)

  -- I can draw a better one if this one feels bad
  bgimg = love.graphics.newImage("dark3.png")

  -- useful global/local variables?
  windowWidth = love.graphics.getWidth()
  windowHeight = love.graphics.getHeight()
  creditsY = windowHeight
  good = false
  perfect = false
  double = false
  rewardCounter = 0
  rewardFrames = 20
  magnetAccel = 25
  releaseFrames = 0
  releaseCounter = 0
  strength = 6.5

  -- for level select
  clickedx = 0
  diffx = 0
  lastx = 0
  scrollv = 0

  playerL = Magnet("left", windowWidth/2, windowHeight-30, 60, 10)
  playerR = Magnet("right", windowWidth/2, windowHeight-30, 60, 10)



  menusound = love.audio.newSource(
    "ambientjam.ogg", "stream")

  -- menu logic (WIP)
  currentScreen = "menu"

  levels = Levels()

  table.insert(menuButtons, newButton("Start",
    function()
      -- Likely first change this to some tutorial page later

      -- currentScreen = "levelOne"
      -- print(currentScreen)
      -- sound = love.audio.newSource(
      --   "Different_Heaven_-_Nekozilla.mp3", "stream")
      -- love.audio.play(sound)
      -- sound:setVolume(0.3)
      -- levels:setLevel(1)

      currentScreen = "SelectLevel"
    end
  ))

  table.insert(menuButtons, newButton("Credits",
    function()
      currentScreen = "credits"
      creditsY = windowHeight
      print("none for now, WIP")
    end
  ))

  table.insert(menuButtons, newButton("Exit",
    function()
      love.event.quit(0)
    end
  ))


end

function love.update(dt)
  if currentScreen:find("level", 1, true) == 1 then
      levels:generate(sound:tell())
      levels:update(dt)

--[[
      if (love.keyboard.isDown("space") == false) and playerL:getPrevious() then
        if releaseCounter < releaseFrames then
          releaseCounter = releaseCounter + 1
        else
          releaseCounter = 0
          playerL:setPrevious()
        end
        ]]
      if love.keyboard.isDown('space') then
        playerL:bounce(strength)
        playerR:bounce(strength)
      else

        playerL:reversebounce(strength)
        playerR:reversebounce(strength)

        --[[
        playerL:update(dt)
        playerR:update(dt)
        playerL:accelerate(magnetAccel)
        playerR:accelerate(magnetAccel)
        ]]
      end
      playerL:centreCollision()
      playerR:centreCollision()
      playerL:wallCollision()
      playerR:wallCollision()
      checkCollisions()

      if not sound:isPlaying() then
        if currentScreen == "levelOne" then
          sound = love.audio.newSource("level_one_long.ogg", "stream")
          love.audio.play(sound)
          love.audio.setVolume(0.5)
          sound.seek(sound, 103, "seconds")
        end
          currentScreen = "endGame"
      end
  elseif currentScreen == "credits" then
    creditsY = creditsY - creditsVel*dt
  end
end

function love.draw()
  local buttonWidth = windowWidth/3
  local buttonHeight = 70
  local margin = 30

  local totalHeight = (buttonHeight + margin)*#menuButtons
  local cursorY = 50

  -- for level select
  local gap = 300
  local levelButtonRadius = 120

  love.graphics.draw(bgimg, 0, 0)

  if currentScreen:find("level", 1, true) == 1 then
    playerL:draw()
    playerR:draw()
    levels:draw(sound:tell())
    love.graphics.print(levels.score, selectionFont, 10, 0)
    local tpb = 60/levels.bpm[levels.level]
    love.graphics.setColor(1, 1, 1, 1-(sound:tell() - math.floor(sound:tell()/tpb)*tpb))

    if good or perfect or double then
      if rewardCounter < rewardFrames then
        if double then
          love.graphics.print("Double!", selectionFont, (windowWidth / 2) - 60, 500)
        elseif perfect then
          love.graphics.print("Perfect!", selectionFont, (windowWidth / 2) - 62.5, 500)
        elseif good then
          love.graphics.print("Good!", selectionFont, (windowWidth / 2) - 37.5, 500)
        end
        rewardCounter = rewardCounter + 1
      elseif rewardCounter == rewardFrames then
        rewardCounter = 0
        good = false
        perfect = false
        double = false
      end
    end
  end

  if currentScreen == "menu" then
    if not menusound:isPlaying() then
      love.audio.play(menusound)
      menusound:setVolume(0.3)
    end


    for i, button in ipairs(menuButtons) do
      button.last = button.now

      button.x = windowWidth/2 - buttonWidth/2
      button.y = windowHeight/2 - totalHeight/2 + cursorY

      local colour = {0.5, 0.8, 0.7, 1}
      local mx, my = love.mouse.getPosition()

      local hot = mx > button.x and mx < button.x + buttonWidth and
        my > button.y and my < button.y + buttonHeight

      if hot then
        colour = {0.7, 0.9, 0.8, 1}
      end

      button.now = love.mouse.isDown(1)
      if button.now and not button.last and hot then
        button.fn()
      end

      -- setColor uses RGB and alpha
      love.graphics.setColor(unpack(colour))
      love.graphics.rectangle("fill",
      button.x, button.y,
      buttonWidth, buttonHeight)

      local textWidth = menuFont:getWidth(button.text)
      local textHeight = menuFont:getHeight(button.text)

      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.print(
        button.text,
        menuFont,
        windowWidth/2 - textWidth/2,
        button.y + textHeight/5)

        cursorY = cursorY + (buttonHeight + margin)
    end
    for i, button in ipairs(levelButtons) do
      button.now = true
      clickedx = 0
      diffx = 0
      scrollv = 0
    end

    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(logo, windowWidth/2 - logo:getWidth()/12, 60, 0.2, 0.2)
    love.graphics.setColor(0, 0, 0, 1)
  end

  if currentScreen == "credits" then
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(esc, 10, 10, 0, 0.15, 0.15)
    love.graphics.setColor(0, 0, 0, 1)

    local creditsText = "Magnet Vox" -- TODO: WRITE ACTUAL CREDITS
    local creditsText2 = "a first time game jam project"
    local creditsText3 = "Programming:"
    local creditsText4 = "Shawn Lu"
    local creditsText5 = "Nick Nadeau"
    local creditsText6 = "Jibin Alex"
    local creditsText7 = "Ivan Feng"
    local creditsText8 = "Music:"
    local creditsText9 = "Ivan Feng"
    local creditsText10 = "Graphics:"
    local creditsText11 = "Shawn Lu"
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(creditsText,
      creditsFont,
      windowWidth/2 - creditsFont:getWidth(creditsText)/2, creditsY)
    love.graphics.print(creditsText2,
      creditsFont,
      windowWidth/2 - creditsFont:getWidth(creditsText2)/2, creditsY + 100)
    love.graphics.print(creditsText3,
      creditsFont,
      windowWidth/2 - creditsFont:getWidth(creditsText3)/2, creditsY + 400)
    love.graphics.print(creditsText4,
        creditsFont,
        windowWidth/2 - creditsFont:getWidth(creditsText4)/2, creditsY + 500)
    love.graphics.print(creditsText5,
        creditsFont,
        windowWidth/2 - creditsFont:getWidth(creditsText5)/2, creditsY + 600)
    love.graphics.print(creditsText6,
        creditsFont,
        windowWidth/2 - creditsFont:getWidth(creditsText6)/2, creditsY + 700)
    love.graphics.print(creditsText7,
        creditsFont,
        windowWidth/2 - creditsFont:getWidth(creditsText7)/2, creditsY + 800)
    love.graphics.print(creditsText8,
        creditsFont,
        windowWidth/2 - creditsFont:getWidth(creditsText8)/2, creditsY + 1100)
    love.graphics.print(creditsText9,
        creditsFont,
        windowWidth/2 - creditsFont:getWidth(creditsText9)/2, creditsY + 1200)
    love.graphics.print(creditsText10,
        creditsFont,
        windowWidth/2 - creditsFont:getWidth(creditsText10)/2, creditsY + 1500)
    love.graphics.print(creditsText11,
        creditsFont,
        windowWidth/2 - creditsFont:getWidth(creditsText10)/2, creditsY + 1600)
  end

  if currentScreen == "SelectLevel" then
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(esc, 10, 10, 0, 0.15, 0.15)
    love.graphics.setColor(0, 0, 0, 1)

    if not menusound:isPlaying() then
      love.audio.play(menusound)
      menusound:setVolume(0.3)
    end

    if #levelButtons <= 0 then
      table.insert(levelButtons, newButton("Level 1",
        function()
          currentScreen = "WaitingToStart"
          love.audio.stop()
          levels:setLevel(1)
        end
      ))
      table.insert(levelButtons, newButton("Level 2",
        function()
          currentScreen = "WaitingToStart"
          love.audio.stop()
          levels:setLevel(2)
        end
      ))
      table.insert(levelButtons, newButton("Coming Soon",
        function()

        end
      ))
      for i, button in ipairs(levelButtons) do
        button.now = true
        button.x = windowWidth/2 + gap * (i-1)
        button.y = windowHeight/2
      end
    end

    for i, button in ipairs(levelButtons) do
      button.last = button.now

      local colour = {0.5, 0.8, 0.7, 1}
      local mx, my = love.mouse.getPosition()
      local actualdiffx = 0

      local hot = (button.x - mx) * (button.x - mx) + (button.y - my) * (button.y - my) <= levelButtonRadius * levelButtonRadius

      if hot then
        colour = {0.7, 0.9, 0.8, 1}
      end

      button.now = love.mouse.isDown(1)

      if button.now and not button.last then
        clickedx = mx
        if hot then
          button.fn()
        end
      end

      if not button.now and button.last then
        if clickedx > 0 then
          button.x = button.x + diffx
        end
        actualdiffx = 0
        if i == #levelButtons then
          diffx = 0
        end
      end
      if button.now then
        if i == 1 then
          scrollv = mx - lastx
          lastx = mx
        end
        diffx = mx - clickedx
        -- just to catch in the bery beginning button.now == true but diffx shouldnt be set
        if clickedx <= 0 then
          actualdiffx = 0
        else
          actualdiffx = diffx
        end
      else
        if i == 1 then
          if scrollv > 30 then
            scrollv = 30
          end
          if levelButtons[#levelButtons].x < 0 then
            scrollv = 1
          end
          if levelButtons[1].x > windowWidth then
            scrollv = -1
          end
        end
        button.x = button.x + scrollv * 3
        if i == #levelButtons then
          scrollv = scrollv * 0.9
          if scrollv * scrollv < 0.1 then
            scrollv = 0
          end
        end
      end
      -- setColor uses RGB and alpha
      love.graphics.setColor(unpack(colour))
      love.graphics.circle("fill",
      button.x + actualdiffx, button.y,
      levelButtonRadius)

      local textWidth = menuFont:getWidth(button.text)
      local textHeight = menuFont:getHeight(button.text)

      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.print(
        button.text,
        menuFont,
        button.x - textWidth/2 + actualdiffx,
        button.y - textHeight/2)

    end
  end

  if currentScreen == "WaitingToStart" then
    if love.keyboard.isDown('space') then
      if levels.level == 1 then
        currentScreen = "levelOne"
        sound = love.audio.newSource(
          "level_one.ogg", "stream")
        love.audio.play(sound)
        sound:setVolume(0.5)
      end
      if levels.level == 2 then
        currentScreen = "levelTwo"
        sound = love.audio.newSource(
          "Trials.mp3", "stream")
        love.audio.play(sound)
        sound:setVolume(0.5)
      end
    else
      love.graphics.setColor(1, 1, 1, 1)
      local instruction = "Press Space to separate\nRelease Space to attact\n\nCollect blocks to get points\n\nExtra points will be earned\nwhen magnets are joined together\n\nPress Space to start"
      local instructionWidth = menuFont:getWidth(instruction)
      love.graphics.print(instruction, creditsFont, windowWidth/2 - instructionWidth/2, 40)
    end
  end

  if currentScreen == "endGame" then
    local text = "GG, your score is " ..(levels.score).."\n click to return to level select"
    love.graphics.print(text, menuFont, 30, 30)
    if love.mouse.isDown(1) then
      love.audio.stop()
      currentScreen = "SelectLevel"
    end

  end
end

function love.keypressed(key)
  if key == "escape" then
    if currentScreen == "credits" then
      currentScreen = "menu"
    elseif currentScreen == "SelectLevel" then
      currentScreen = "menu"
    end
  end
end

function checkCollisions()
  LXLocation, LYLocation, MagnetHeight, MagnetWidth = playerL:getMagnetProperties()
  RXLocation, RYLocation, MagnetHeight2, MagnetWidth2 = playerR:getMagnetProperties()
  if levels:resolveDoubleCollisions(LXLocation, LYLocation, RXLocation, MagnetHeight, MagnetWidth) == false then
    levels:resolveLCollisions(LXLocation, LYLocation, MagnetHeight, MagnetWidth)
    levels:resolveRCollisions(RXLocation, RYLocation, MagnetHeight2, MagnetWidth2)
  end
end

function toggleGood()
  if good == false then
    good = true
    if double or perfect then
      double = false
      perfect = false
    end
  else
    rewardCounter = 0
  end
end

function togglePerfect()
  if perfect == false then
    perfect = true
    if double or good then
      double = false
      good = false
    end
  else
    rewardCounter = 0
  end
end

function toggleDouble()
  if double == false then
    double = true
    if good or perfect then
      good = false
      perfect = false
    end
  else
    rewardCounter = 0
  end
end
