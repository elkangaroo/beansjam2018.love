local app = {}
app.version = 0.1
app.camera = nil
app.screen = {}
app.entities = {}
app.audio = {
  volume = 1.0
}
app.images = {
  bgSpeed = 100
}

function love.load(...)
  love.graphics.setDefaultFilter('nearest', 'nearest')

  app.camera = require('lib.camera')

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

  camera:newLayer(0.33, function()
    quad = love.graphics.newQuad(0, 0, app.screen.width * 10, app.screen.height, 256, 192)
    love.graphics.draw(app.images.bg.far, quad, 0, 0, 0, app.screen.height / 192)
  end)

  camera:newLayer(0.66, function()
    quad = love.graphics.newQuad(0, 0, app.screen.width * 10, app.screen.height, 256, 192)
    love.graphics.draw(app.images.bg.back, quad, 0, 0, 0, app.screen.height / 192)
  end)

  camera:newLayer(1, function()
    quad = love.graphics.newQuad(0, 0, app.screen.width * 10, app.screen.height, 352, 192)
    love.graphics.draw(app.images.bg.front, quad, 0, 0, 0, app.screen.height / 192)
  end)
end

function love.update(dt)
  local moveX = app.images.bgSpeed * dt

  app.camera:move(moveX, 0)
  -- camera:setPosition(love.mouse.getX() * 2, love.mouse.getY() * 2)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  app.camera:draw()

  app:drawTextCentered([[
    Touch to play.
    Swipe to move camera.
  ]], { 1, 1, 1 })

  love.graphics.setColor(0.3, 0.9, 1)
  love.graphics.print('v' .. app.version .. ' FPS: ' .. love.timer.getFPS(), 2, 2)
end

function love.focus(focused)
  app.audio.bg:setVolume(focused and app.audio.volume or 0.0)
end

function love.quit()

end

function love.keypressed(key, scancode, isrepeat)
  print('key ' .. key)

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
end

function love.mousereleased(x, y, button, istouch, presses)

end

function love.mousemoved(x, y, dx, dy, istouch)
  print('mouse move ' .. dx .. dy)

  app.camera:move(-dx, 0)
end

function love.wheelmoved(dx, dy)
  print('wheel move ' .. dx .. dy)

  if dy ~= 0 then
    app.camera:scale(1 - (dy * 0.1))
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)

end

function love.touchreleased(id, x, y, dx, dy, pressure)

end

function love.touchmoved(id, x, y, dx, dy, pressure)

end

function app:drawTextCentered(text, color)
  love.graphics.push()
    limit = app.screen.width - 100
    font = love.graphics.getFont()
    _, lines = font:getWrap(text, limit)
    x, y = app.screen.centerX - limit / 2, app.screen.centerY - font:getHeight() * #lines / 2

    love.graphics.setColor(color)
    love.graphics.printf(text, x, y, limit, "center")
  love.graphics.pop()
end
