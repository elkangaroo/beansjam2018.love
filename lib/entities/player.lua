player = {}
player.scale = 1
player.state = nil
player.animationSpeed = 6
player.animations = {}
player.position = { x = nil, y = nil}
player.alive = true

local animator = require('lib.animator')

local STATE_IDLE = 1
local STATE_THROW = 2
local STATE_WALK = 3
local STATE_STAB = 4
local STATE_DIE = 5

function player:load(position, scale)
  self.state = STATE_IDLE
  self.position = position
  self.scale = scale or 1

  local playerImage = love.graphics.newImage('resources/night_thief.png')
  local playerImageGrid = animator.newGrid(32, 32, playerImage)

  self.animations[STATE_IDLE] = animator.newAnimation(playerImageGrid('1-10', STATE_IDLE), 1, playerImage)
  self.animations[STATE_IDLE]:setLooping(true)

  self.animations[STATE_WALK] = animator.newAnimation(playerImageGrid('1-10', STATE_WALK), 1, playerImage)
  self.animations[STATE_WALK]:setLooping(true)

  self.animations[STATE_DIE] = animator.newAnimation(playerImageGrid('1-10', STATE_DIE), 1, playerImage)
  self.animations[STATE_DIE]:setPauseAtEnd(true)
  self.animations[STATE_DIE]:setOnAnimationChange(function(anim, frame)
    player.alive = (frame < 10)
  end)
end

function player:update(dt)
  self.animations[self.state]:update(self.animationSpeed * dt)
end

function player:draw()
  self.animations[self.state]:draw(self.position.x - 32 * self.scale / 2, self.position.y - 32 * self.scale, 0, self.scale, self.scale)
end

function player:keypressed(key)
  if self.animations[tonumber(key)] then
    self.animations[tonumber(key)]:restart()
    self.state = tonumber(key)
  end
end

function player:mousepressed(x, y, button)
  if 1 == button then
    self.state = self.state == STATE_WALK and STATE_IDLE or STATE_WALK
  end
end

function player:isIdle()
  return STATE_IDLE == self.state
end

function player:isWalking()
  return STATE_WALK == self.state
end

function player:isDead()
  return STATE_DIE == self.state and not self.alive
end

return player
