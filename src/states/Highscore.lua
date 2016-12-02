

--===============--
--== menuState ==--
--===============--
local Highscore = state:new()


--== Load ==--
function Highscore.load()
  --== PostProcessing
  local grain     = shine.filmgrain()
  local scanlines = shine.scanlines()
  scanlines.parameters = {pixel_size = 3, opacity = 0.2 }
  local vignette  = shine.vignette()
  vignette.parameters = {radius = 0.4, opacity = 0.2}
  post_effect = vignette:chain(scanlines):chain(grain)

  MenuOptions = {"Try Again", "Quit to Menu"}
  currentlyActive = 1

  screenW, screenH = love.graphics.getDimensions()

end

--== Update ==--
function Highscore.update(dt)
end

--== Draw ==--
function Highscore.draw()
  post_effect:draw(function()
    -- Draw Highscore
    love.graphics.setColor(Colors.white)
    love.graphics.printf("Highscore", 0, 100, screenW, "center")

    for i,option in ipairs(MenuOptions) do
      if i == currentlyActive then
        love.graphics.setColor(Colors.white)
      else
        love.graphics.setColor(Colors.lightgrey)
      end

      love.graphics.printf(option, 0, 132+50*i, screenW, "center")
    end

  end)
end

function Highscore.unload()

end

function Highscore.nextItem()
  if currentlyActive == #MenuOptions then currentlyActive = 1
  else
    currentlyActive = currentlyActive + 1
  end
end

function Highscore.previousItem()
  if currentlyActive == 1 then currentlyActive = #MenuOptions
  else
    currentlyActive = currentlyActive - 1
  end
end


--== External ==--
function love.keypressed(key, scancode, isrepeat)
  if key == "up" then
    Highscore.previousItem()
  end
  if key == "down" then
    Highscore.nextItem()
  end

  if key == "return" then
    selection = MenuOptions[currentlyActive]

    if selection == "Try Again" then
      state:switch("src.states.Game")
    elseif selection == "Quit to Menu" then
      state:switch("src.states.Menu")
    end

    print("Highscore Select: " .. MenuOptions[currentlyActive])
  end

end

return Highscore
