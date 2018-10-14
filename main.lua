local app = {}
app.version = 1.0
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
app.timer = 0
app.timerMax = 0

-- Initialize the pseudo random number generator
math.randomseed(os.time())
math.random()
math.random()
math.random()

function love.load(...)
  love.graphics.setDefaultFilter('nearest', 'nearest')

  app.timer = 0
  app.timerMax = math.random(30)

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
    app.timer = app.timer + dt
    app.camera:move(app.images.bgSpeed * dt, 0)
  end

  app.entities.player:update(dt, app.timer > app.timerMax)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)

  app.camera:draw()
  app.entities.player:draw()

  if app.entities.player:isIdle() then
    app:drawTextCentered('Touch to play.', { 1, 1, 1 })
  end

  if app.entities.player:isDead() then
    app:drawTextCentered('Game Over.', { 1, 1, 1 })
  end

  love.graphics.setColor(0.3, 0.9, 1)
  love.graphics.setFont(app.fonts.small)
  love.graphics.print(string.format('v%s FPS: %s Time: %s', app.version, love.timer.getFPS(), (math.floor(app.timer * 10) * 0.1)), 2, 2)
end

function love.focus(focused)
  app.audio.bg:setVolume(focused and app.audio.volume or 0.0)
end

function love.quit()

end

function love.keypressed(key, scancode, isrepeat)
  if 'escape' == key then
    love.event.push('quit')
  end
end

function love.keyreleased(key, scancode)

end

function love.mousepressed(x, y, button, istouch, presses)
  app.entities.player:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button, istouch, presses)

end

function love.mousemoved(x, y, dx, dy, istouch)

end

function love.wheelmoved(dx, dy)

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
