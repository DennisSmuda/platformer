--=====================--
--== Libraries ========--
--=====================--
class   = require "lib.middleclass" -- Classes
push    = require "lib.push"    -- Resolution Handling
screen  = require "lib.shack"   -- Screen effects (shake, rotate, shear, scale)
lem     = require "lib.lem"     -- Events
lue     = require "lib.lue"     -- Hue
state   = require "lib.stager"  -- Scenes and transitions
audio   = require "lib.wave"    -- Audio
trail   = require "lib.trail"   -- Trails
soft    = require "lib.soft"    -- Lerp
tween   = require "lib.tween"    -- Easing
shine   = require "lib.shine"   -- PostProcessing
bump    = require "lib.bump"    -- Collision
Camera  = require "lib.camera"  -- Camera
Signal  = require "lib.signal"  -- Eventing
anim8   = require "lib.anim8"   -- Anim
sti     = require "lib.sti"   -- Anim

--==
Colors = require "src.config.Colors"


--== Load Sounds
blockbreak_sound = audio:newSource("assets/sounds/block_break.wav", "static"):setVolume(0.5)
blockhit_sound   = audio:newSource("assets/sounds/block_hit.wav", "static"):setVolume(0.5)
envhit_sound     = audio:newSource("assets/sounds/environment_hit.wav", "static"):setVolume(0.5)
ballOOB_sound    = audio:newSource("assets/sounds/ball_oob.wav", "static"):setVolume(0.5)

blockbreak_sound:setVolume(0.3)
blockhit_sound:setVolume(0.3)
envhit_sound:setVolume(0.3)
ballOOB_sound:setVolume(0.3)

windowW, windowH = love.graphics.getDimensions()

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end -- Debug code for ZeroBrane

  love.window.setMode(1000, 600, {fullscreen=false, vsync=true, resizable=false})
  -- love.graphics.setBackgroundColor(95, 205, 228)


  font = love.graphics.newFont("assets/fonts/slkscr.ttf", 30)
  game_font = love.graphics.newFont("assets/fonts/slkscr.ttf", 8)
  font:setFilter("nearest", "nearest")
  game_font:setFilter("nearest", "nearest")
  -- print(font:getFilter())
  love.graphics.setFont(game_font)

  loadGraphics()

  state:switch("src.states.Game" ,{})

  --== Screen Dimension Globals
  windowW, windowH = love.graphics.getDimensions()

end

function love.update(dt)
  state:update(dt)
end

function love.draw()
  state:draw()
end


function loadGraphics()
  love.graphics.setDefaultFilter("nearest", "nearest")
  inventoryFrame_img = love.graphics.newImage("assets/img/inventory_frame.png")
  particle_img  = love.graphics.newImage("assets/img/particle.png")
  blaster_right = love.graphics.newImage("assets/img/blaster_right.png")
  blaster_left  = love.graphics.newImage("assets/img/blaster_left.png")
  bullet_img    = love.graphics.newImage("assets/img/bullet.png")
  portal_purple_img    = love.graphics.newImage("assets/img/portal.png")
  portal_green_img = love.graphics.newImage("assets/img/portal_green.png")
  stone_img     = love.graphics.newImage("assets/img/stone.png")
  cloud_img     = love.graphics.newImage("assets/img/cloud.png")
  heart_img     = love.graphics.newImage("assets/img/inventory_frame.png")

  --== Tileset ===
  tileset     = love.graphics.newImage("assets/img/tileset.png")

  blockQuad       = love.graphics.newQuad(0, 0, 18, 18, tileset:getDimensions())
  grassQuad       = love.graphics.newQuad(18, 0, 18, 18, tileset:getDimensions())
  earthQuad       = love.graphics.newQuad(36, 0, 18, 18, tileset:getDimensions())
  earthEmptyQuad  = love.graphics.newQuad(36, 18, 18, 18, tileset:getDimensions())
  boundaryBlockQuad = love.graphics.newQuad(0, 18, 18, 18, tileset:getDimensions())

  --== TODO: Fragmentset doesnt work, instead uses tileset..
  fragment_set      = love.graphics.newImage("assets/img/fragmentset.png")
  blockFragmentQuad = love.graphics.newQuad(0, 0, 10, 10, fragment_set:getDimensions())
  earthFragmentQuad = love.graphics.newQuad(10, 0, 10, 10, fragment_set:getDimensions())

  playerset = love.graphics.newImage("assets/img/player.png")
  playerG   = anim8.newGrid(12,12, playerset:getDimensions())

  explosionset     = love.graphics.newImage("assets/img/explosion.png")
  block_damage_set = love.graphics.newImage("assets/img/block_break_frames.png")
  block_damage_1   = love.graphics.newQuad(0,0,16,16, block_damage_set:getDimensions())
  block_damage_2   = love.graphics.newQuad(16,0,16,16, block_damage_set:getDimensions())
  block_damage_3   = love.graphics.newQuad(32,0,16,16, block_damage_set:getDimensions())
  block_damage_4   = love.graphics.newQuad(48,0,16,16, block_damage_set:getDimensions())



  --== Player Animations
  walkingRight    = anim8.newAnimation(playerG('1-2', 1), 0.15)
  walkingLeft     = anim8.newAnimation(playerG('3-4', 1), 0.15)
  wallSlideRight  = anim8.newAnimation(playerG('5-6', 1), 0.2)
  wallSlideLeft   = anim8.newAnimation(playerG('5-6', 2), 0.2)
  idleRight       = anim8.newAnimation(playerG('1-2', 2), 0.3)
  idleLeft        = anim8.newAnimation(playerG('3-4', 2), 0.3)
  jumpRight       = anim8.newAnimation(playerG('1-2', 3), 0.2)
  jumpLeft        = anim8.newAnimation(playerG('3-4', 3), 0.2)
  floating        = anim8.newAnimation(playerG('5-5', 3), 0.2)
  downing         = anim8.newAnimation(playerG('1-1', 4), 0.2)

end
