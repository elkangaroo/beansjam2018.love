local app = {}
app.version = 0.1
app.camera = nil
app.screen = {}
app.entities = {}
app.audio = {
  volume = 1.0,
  tracks = {
    'summertime.mp3'
  }
}

function love.load(...)
  app.camera = require('lib.camera')

  app.screen.width = love.graphics.getWidth()
  app.screen.height = love.graphics.getHeight()
  app.screen.centerX = app.screen.width / 2
  app.screen.centerY = app.screen.height / 2

  app.audio.background = love.audio.newSource(
    'resources/' .. app.audio.tracks[math.random(#app.audio.tracks)],
    'stream'
  )
  app.audio.background:setVolume(app.audio.volume)
  app.audio.background:setLooping(true)

  love.audio.play(app.audio.background)

	player = { x = app.screen.centerX - 25, y = 400, width = 50, height = 50 }

  for i = .5, 2, .5 do
    local rectangles = {}

    for j = 1, math.random(2, 15) do
      table.insert(rectangles, {
        math.random(0, 1600),
        math.random(0, 1600),
        math.random(50, 400),
        math.random(50, 400),
        color = { math.random(), math.random(), math.random() }
      })
    end

    camera:newLayer(i, function()
      for _, v in ipairs(rectangles) do
        love.graphics.setColor(v.color)
        love.graphics.rectangle('fill', unpack(v))
        love.graphics.setColor(1, 1, 1)
      end
    end)
  end
end

function love.update(dt)

end

function love.draw()
  love.graphics.print("FPS: " .. love.timer.getFPS(), 2, 2)
  app.camera:draw()

  app:drawTextCentered([[
    Touch to play.
    Swipe to move camera.
  ]], { 0.3, 0.75, 0.95, 1 })

  love.graphics.push()
    love.graphics.setColor(1, 1, 1)
  	love.graphics.rectangle("fill",  player.x, player.y, player.width, player.height)
  love.graphics.pop()
end

function love.focus(focused)
  app.audio.background:setVolume(focused and app.audio.volume or 0.0)
end

function love.quit()

end

function love.keypressed(key, scancode, isrepeat)
  print('key ' .. key)

  if 'm' == key then
    app.audio.background:setVolume(app.audio.background:getVolume() == 0.0 and app.audio.volume or 0.0)
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
