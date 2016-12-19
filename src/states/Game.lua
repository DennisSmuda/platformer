require "src.config.Levels"
require "src.ui.GameOverlay"
require "src.world.Level"
require "src.world.player.Player"


local Game = state:new()

--== Globals
gamestate = {
  destinations  = {
    home  = { x = 2, y = 2},
    caves = { x = 1, y = 1},
  }
}


function Game.load (args)
  --== PostProcessing
  local grain     = shine.filmgrain()
  grain.parameters = { grainsize = 1, opacity = 0.1}
  local scanlines = shine.scanlines()
  scanlines.parameters = {pixel_size = 3, opacity = 0.2 }
  local vignette  = shine.vignette()
  vignette.parameters = {radius = 0.5, opacity = 0.3}
  post_effect = scanlines:chain(grain):chain(vignette)

  love.graphics.setFont(game_font)


  --== Setup Game World
  world = bump.newWorld(8)

  level = Level()
  player = Player()
  -- cloud = Cloud()


  --== Camera
  screenW, screenH = love.graphics.getDimensions()
  camera = Camera()
  camera:zoom(3)

  local dx, dy = screenW - camera.x, screenH - camera.y
  camera:lookAt(screenW/2, screenH/2)


end


function Game.update (dt)

  level:update(dt)
  screen:update(dt)

  player:update(dt)


   local dx,dy = player.x - camera.x, player.y - camera.y
   camera:move(dx*0.09, dy*0.09)

end




function Game.draw()

  screen:apply()

  post_effect:draw(function()

    camera:attach()

      level:drawTiles()
      level:drawStatics()
      
      player:draw()
      -- platform:draw()
      level:drawCollectibles()
      player:drawInventory()

    camera:detach()


  end)

end


function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then state:switch("src.states.Menu") end

  if key == "tab" then player.inventory:toggle() end

end

return Game
