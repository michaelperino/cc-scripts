local d,w = ...
slot = 1
d = tonumber(d)
w = tonumber(w)
items = {}
items[1] = "minecraft:cobbled_deepslate"
items[2] = "rechiseled:glowstone_smooth"
turn = "right"
rednet.open("left")
dig = true

while w > 0 do
  d2 = d
  if turtle.getFuelLevel() < 6000 then
      turtle.select(16)
      turtle.placeUp()
      turtle.select(14)
      turtle.dropDown(64)
      rednet.broadcast("0060 minecraft:coal")
      reccy = -1
      while reccy ~= os.computerID() do
          s,m = rednet.receive()
          reccy = tonumber(string.sub(m,1,5))
      end
      turtle.suckUp(64)
      turtle.refuel(64)
      turtle.select(16)
      turtle.digUp()
  end
  while d2 > 0 do
      if (math.mod(d2,4)-2) == 0 and (math.mod(w,4)-2) == 0 then
          slot = 2
      else
          slot = 1
      end
      if turtle.getItemCount(slot) < 10 then
          turtle.select(16)
          request = string.format("%04d %s",40,items[slot])
          reccy = -1
          rednet.broadcast(request)
          while reccy ~= os.computerID() do
              s,m = rednet.receive(15)
              if s == nil then
                  rednet.broadcast(request)
              else
                  reccy = tonumber(string.sub(m,1,5))
              end
          end
          turtle.digUp()
          turtle.placeUp()
          turtle.select(slot)
          turtle.drop(64)
          turtle.suckUp(64)
          turtle.select(16)
          turtle.digUp()
      end
      turtle.select(slot)
      turtle.digDown()
      turtle.placeDown()
      d2 = d2 - 1
      if d2 > 0 then
          if dig then
              turtle.dig()
              turtle.digUp()
          end
          turtle.forward()
      end
  end
  w = w - 1
  if turn == "right" then
      turtle.turnRight()
      if dig then
          turtle.dig()
          turtle.digUp()
      end
      turtle.forward()
      turtle.turnRight()
      turn = "left"
  else
      turtle.turnLeft()
      if dig then
          turtle.dig()
          turtle.digUp()
      end
      turtle.forward()
      turtle.turnLeft()
      turn = "right"
  end
end