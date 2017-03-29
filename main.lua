--[[
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
--]]

--tested on LOVE 0.10.2 (Super Toast)

local anim8 = require 'libs/anim8' -- https://github.com/kikito/anim8
local img, playerAnimation, flip
local player = {x = 100, y = 200, flip = 8, iW = nil, img = nil}

function love.load()
  player.img = love.graphics.newImage('assets/hero.png') --sprite sheet downloaded from http://opengameart.org/content/classic-hero under public domain license
  player.iW = 0
  local g = anim8.newGrid(16, 16, player.img:getWidth(), player.img:getHeight(), 16, 16)
  local idleFrames = g('1-4',1)
  local runFrames = g('1-6', 2)
  idleAnimation = anim8.newAnimation(idleFrames, 0.3)
  runAnimation = anim8.newAnimation(runFrames, 0.1)
  currentAnimation = idleAnimation
  music = love.audio.newSource('assets/snow.ogg', 'static') --downloaded from http://www.freesound.org/people/ShadyDave/sounds/262259/ CC BY-NC 3.0 author ShadyDave
  music:setLooping(true)
  music:play()
end

function love.draw()

  currentAnimation:draw(player.img, player.x, player.y, 0, player.flip, 8, player.iW, 0)

end

function love.update(dt)
  if (love.keyboard.isDown('right')) then
    currentAnimation = runAnimation
    player.flip = 8 -- set to 8 to make the image large enough to see the animations
    player.iW = 0 -- when facing right we don't need an offset
    player.x = player.x + 300 * dt
  end
  if (love.keyboard.isDown('left')) then
    currentAnimation = runAnimation
    player.flip = -8 -- set to -8 to flip the image and make it large enough to see animations
    player.iW = 16 -- since image is flipped at origin point, we need to move the image to the right 16
    player.x = player.x - 300 * dt
  end
  if ((love.keyboard.isDown('left')) and (love.keyboard.isDown('right'))) then
    currentAnimation = idleAnimation
  end
  currentAnimation:update(dt)
end

function love.keyreleased(key)
  if key == 'right' or key == 'left' then
    currentAnimation = idleAnimation
    idleAnimation:gotoFrame(1)
  end
end
