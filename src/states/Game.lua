require "src.config.Levels"
require "src.ui.GameOverlay"
require "src.ui.GameBackdrop"
require "src.level.platform"
require "src.level.Level"
require "src.Player"
require "src.Block"
require "src.Ball"
require "src.Wall"
require "src.Block"
require "src.LevelManager"


local Game = state:new()

--== Globals


function Game.load (args)
  --== PostProcessing
  local grain     = shine.filmgrain()
  local scanlines = shine.scanlines()
  scanlines.parameters = {pixel_size = 3, opacity = 0.2 }
  local vignette  = shine.vignette()
  vignette.parameters = {radius = 0.7, opacity = 0.3}
  -- post_effect = scanlines:chain(grain):chain(vignette)
  post_effect = scanlines:chain(grain)


  --== Setup Game World
  world = bump.newWorld(8)
  level = Level()


  player = Player()
  platform = Platform(1,1)
  cloud = Cloud()


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
   camera:move(dx/2, dy/2)

end




function Game.draw()

  screen:apply()



  -- post_effect:draw(function()

    camera:attach()

      cloud:draw()

      player:draw()
      -- platform:draw()
      level:draw()

    camera:detach()

  -- end)

end


function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then state:switch("src.states.Menu") end


end

return Game
