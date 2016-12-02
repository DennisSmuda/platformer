

--===============--
--== menuState ==--
--===============--
local Menu = state:new()


--== Load ==--
function Menu.load()
  --== PostProcessing
  local grain     = shine.filmgrain()
  local scanlines = shine.scanlines()
  scanlines.parameters = {pixel_size = 3, opacity = 0.2 }
  local vignette  = shine.vignette()
  vignette.parameters = {radius = 0.4, opacity = 0.2}
  post_effect = vignette:chain(scanlines):chain(grain)

  MenuOptions = {"PLAY", "OPTIONS", "QUIT"}
  currentlyActive = 1

  screenW, screenH = love.graphics.getDimensions()

end

--== Update ==--
function Menu.update(dt)
end

--== Draw ==--
function Menu.draw()
  post_effect:draw(function()
    -- Draw Menu
    love.graphics.setColor(Colors.white)
    love.graphics.printf("Main Menu", 0, 100, screenW, "center")

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

function Menu.unload()

end

function Menu.nextItem()
  if currentlyActive == #MenuOptions then currentlyActive = 1
  else
    currentlyActive = currentlyActive + 1
  end
end

function Menu.previousItem()
  if currentlyActive == 1 then currentlyActive = #MenuOptions
  else
    currentlyActive = currentlyActive - 1
  end
end


--== External ==--
function love.keypressed(key, scancode, isrepeat)
  if key == "up" then
    Menu.previousItem()
  end
  if key == "down" then
    Menu.nextItem()
  end

  if key == "return" then
    selection = MenuOptions[currentlyActive]

    if selection == "PLAY" then
      state:switch("src.states.Game")
    elseif selection == "QUIT" then
      love.event.quit()
    end

  end

end

return Menu
