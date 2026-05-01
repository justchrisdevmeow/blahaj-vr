function lovr.load()
  lovr.headset.setTrackingOrigin('floor')
  
  blahaj = lovr.graphics.newModel('blahaj.glb')
  blahaj:setScale(0.5)
  blahaj:setPosition(0, 0, -2)
  
  grabbed = false
  grabOffset = lovr.math.newVec3(0, 0, 0)
  
  meow = lovr.audio.newSource('meow.wav', 'static')
end

function lovr.update(dt)
  local rightHand = lovr.headset.getHandPose('right')
  local leftAxis = lovr.headset.getAxis('left', 'thumbstick')
  
  -- Movement
  if leftAxis then
    local camera = lovr.headset.getViewPose()
    local move = lovr.math.newVec3(leftAxis.x, 0, -leftAxis.y) * dt * 3
    move:rotate(camera:getQuat())
    local pos = camera:getPosition()
    lovr.headset.setPosition(pos + move)
  end
  
  -- Grab/release
  if lovr.headset.isDown('right', 'trigger') then
    if not grabbed then
      local handPos = rightHand:getPosition()
      local blahajPos = blahaj:getPosition()
      if handPos:distance(blahajPos) < 0.5 then
        grabbed = true
        grabOffset = handPos - blahajPos
        meow:play()
      end
    else
      local handPos = rightHand:getPosition()
      blahaj:setPosition(handPos - grabOffset)
    end
  else
    grabbed = false
  end
end

function lovr.draw(pass)
  pass:draw(blahaj, blahaj:getMatrix())
  
  local handPos = lovr.headset.getHandPose('right'):getPosition()
  if not grabbed and handPos:distance(blahaj:getPosition()) < 0.5 then
    pass:setColor(0, 1, 0, 0.3)
    pass:sphere(blahaj:getPosition(), 0.6)
  end
end
