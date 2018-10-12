local app = {}
app.version = 0.1
app.showdebug = false
app.showhelp = false
app.entities = {}
app.audio = {
  volume = 1.0,
  tracks = {
    'summertime.mp3'
  }
}

function love.load(...)
  app.audio.background = love.audio.newSource('resources/' .. app.audio.tracks[math.random(#app.audio.tracks)], 'stream')
  app.audio.background:setVolume(app.audio.volume)
  app.audio.background:setLooping(true)

  love.audio.play(app.audio.background)
end

function love.update(dt)

end

function love.draw()

end

function love.focus(focused)
  app.audio.background:setVolume(app.audio.volume)
end

function love.quit()

end

function love.keypressed(key, unicode)
  if 'm' == key then
    app.audio.background:setVolume(app.audio.background:getVolume() == 0.0 and app.audio.volume or 0.0)
  end
  if 'escape' == key then
    love.event.push('quit')
  end
end

function love.keyreleased(key, unicode)

end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.joystickpressed(joystick, button)

end

function love.joystickreleased(joystick, button)

end

function love.touchpressed(id, x, y, dx, dy, pressure)

end

function love.touchreleased(id, x, y, dx, dy, pressure)

end
