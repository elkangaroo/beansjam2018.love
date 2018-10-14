player = {}
player.scale = 4
player.state = nil
player.animationSpeed = 6
player.animations = {}
player.position = { x = nil, y = nil}

local animator = require('lib.animator')

local STATE_IDLE = 1
local STATE_THROW = 2
local STATE_WALK = 3
local STATE_STAB = 4
local STATE_DIE = 5

function player:load(position)
  self.state = STATE_IDLE
  self.position = position

  local playerImage = love.graphics.newImage('resources/night_thief.png')
  local playerImageGrid = animator.newGrid(32, 32, playerImage)

  self.animations[STATE_IDLE] = animator.newAnimation(playerImageGrid('1-10', STATE_IDLE), 1, playerImage)
  self.animations[STATE_IDLE]:setLooping(true)

  self.animations[STATE_WALK] = animator.newAnimation(playerImageGrid('1-10', STATE_WALK), 1, playerImage)
  self.animations[STATE_WALK]:setLooping(true)

  self.animations[STATE_DIE] = animator.newAnimation(playerImageGrid('1-10', STATE_DIE), 1, playerImage)
  self.animations[STATE_DIE]:setPauseAtEnd(true)
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

function player:isWalking()
  return STATE_WALK == self.state
end

return player
