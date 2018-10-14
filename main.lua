local app = {}
app.version = 0.1
app.camera = require('lib.camera')
app.animator = require('lib.animator')
app.screen = {}
app.entities = {}
app.audio = {
  volume = 0.5
}
app.images = {
  bgSpeed = 40
}
app.fonts = {}

function love.load(...)
  love.graphics.setDefaultFilter('nearest', 'nearest')

  app.fonts.small = love.graphics.newFont('resources/boxy_bold.ttf', 16)
  app.fonts.medium = love.graphics.newFont('resources/boxy_bold.ttf', 32)
  app.fonts.large = love.graphics.newFont('resources/boxy_bold.ttf', 64)

  app.screen.width = love.graphics.getWidth()
  app.screen.height = love.graphics.getHeight()
  app.screen.centerX = app.screen.width / 2
  app.screen.centerY = app.screen.height / 2

  app.audio.bg = love.audio.newSource('resources/bgmusic.mp3', 'stream')
  app.audio.bg:setVolume(app.audio.volume)
  app.audio.bg:setLooping(true)

  love.audio.play(app.audio.bg)

  app.images.bg = {
    far = love.graphics.newImage('resources/cyberpunk_buildings_far.png'),
    back = love.graphics.newImage('resources/cyberpunk_buildings_back.png'),
    front = love.graphics.newImage('resources/cyberpunk_buildings_front.png')
  }
  app.images.bg.far:setWrap('repeat')
  app.images.bg.back:setWrap('repeat')
  app.images.bg.front:setWrap('repeat')

  local bgHeight = 192
  local scale = app.screen.height / bgHeight

  camera:newLayer(0.33, function()
    quad = love.graphics.newQuad(0, 0, app.screen.width * 100, bgHeight, 256, bgHeight)
    love.graphics.draw(app.images.bg.far, quad, 0, 0, 0, scale)
  end)

  camera:newLayer(0.66, function()
    quad = love.graphics.newQuad(0, 0, app.screen.width * 100, bgHeight, 256, bgHeight)
    love.graphics.draw(app.images.bg.back, quad, 0, 0, 0, scale)
  end)

  camera:newLayer(1, function()
    quad = love.graphics.newQuad(0, 0, app.screen.width * 100, bgHeight, 352, bgHeight)
    love.graphics.draw(app.images.bg.front, quad, 0, 0, 0, scale)
  end)

  app.entities.player = require('lib.entities.player')
  app.entities.player:load({ x = app.screen.centerX, y = app.screen.height - 134}, scale)
end

function love.update(dt)
  if app.entities.player:isWalking() then
    local moveX = app.images.bgSpeed * dt
    app.camera:move(moveX, 0)
  end

  app.entities.player:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)

  app.camera:draw()
  app.entities.player:draw()

  app:drawTextCentered('Touch to play.', { 1, 1, 1 })

  love.graphics.setColor(0.3, 0.9, 1)
  love.graphics.setFont(app.fonts.small)
  love.graphics.print('v' .. app.version .. ' FPS: ' .. love.timer.getFPS(), 2, 2)
end

function love.focus(focused)
  app.audio.bg:setVolume(focused and app.audio.volume or 0.0)
end

function love.quit()

end

function love.keypressed(key, scancode, isrepeat)
  print('key ' .. key)

  app.entities.player:keypressed(key)

  if 'm' == key then
    app.audio.bg:setVolume(app.audio.bg:getVolume() == 0.0 and app.audio.volume or 0.0)
  end
  if 'escape' == key then
    love.event.push('quit')
  end
end

function love.keyreleased(key, scancode)

end

function love.mousepressed(x, y, button, istouch, presses)
  print('mouse ' .. button)

  app.entities.player:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button, istouch, presses)

end

function love.mousemoved(x, y, dx, dy, istouch)
  print('mouse move ' .. dx .. dy)

  if app.entities.player:isWalking() then
    if dx < 0 then
      app.camera:move(-dx, 0)
    end
  end
end

function love.wheelmoved(dx, dy)
  print('wheel move ' .. dx .. dy)

  if dy ~= 0 then
    -- app.camera:scale(1 - (dy * 0.1))
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)

end

function love.touchreleased(id, x, y, dx, dy, pressure)

end

function love.touchmoved(id, x, y, dx, dy, pressure)

end

function app:drawTextCentered(text, color, y)
  love.graphics.push()
    limit = app.screen.width
    font = love.graphics.getFont()
    _, lines = font:getWrap(text, limit)
    x, y = app.screen.centerX - limit / 2, y or app.screen.centerY - font:getHeight() * #lines / 2

    love.graphics.setColor(color)
    love.graphics.setFont(app.fonts.medium)
    love.graphics.printf(text, x, y, limit, "center")
  love.graphics.pop()
end
