local app = {}
app.version = 0.1
app.camera = nil
app.entities = {}
app.audio = {
  volume = 1.0,
  tracks = {
    'summertime.mp3'
  }
}

function love.load(...)
  app.camera = require('lib.camera')

  app.audio.background = love.audio.newSource(
    'resources/' .. app.audio.tracks[math.random(#app.audio.tracks)],
    'stream'
  )
  app.audio.background:setVolume(app.audio.volume)
  app.audio.background:setLooping(true)

  love.audio.play(app.audio.background)

	player = {x=250, y=250, width=15, height=15}
	enemy = {x=300, y=400, width=15, height=15}
end

function love.update(dt)

end

function love.draw()
  app.camera:set()

  love.graphics.push()
    love.graphics.setColor(85/255, 190/255, 240/255)
    love.graphics.print([[
      mouse : move camera
      m     : toggle music
      esc   : quit
    ]], 10, 10)
  love.graphics.pop()

  love.graphics.push()
    love.graphics.setColor(1, 1, 1)
  	love.graphics.rectangle("fill",  player.x, player.y, player.width, player.height)
  love.graphics.pop()

  love.graphics.push()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill",  enemy.x, enemy.y, enemy.width, enemy.height)
  love.graphics.pop()

  app.camera:unset()
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

  app.camera:move(-dx, -dy)
end

function love.wheelmoved(dx, dy)
  print('wheel move ' .. dx .. dy)

  if dy ~= 0 then
    app.camera:scale(1 - (-dy * 0.1))
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)

end

function love.touchreleased(id, x, y, dx, dy, pressure)

end

function love.touchmoved(id, x, y, dx, dy, pressure)

end
