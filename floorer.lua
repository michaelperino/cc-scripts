local d,w = ...
slot = 1
d = tonumber(d)
w = tonumber(w)
items = {}
items[1] = "minecraft:cobbled_deepslate"
items[2] = "rechiseled:glowstone_smooth"
turn = "right"
dig = true

h = peripheral.wrap("right")
if h ~= nil then
    turtle.select(14)
    turtle.equipRight()
end

function item_RS_request(item, amount, slotty)
    turtle.select(14)
    turtle.digUp()
    turtle.equipRight()
    request = string.format("%04d %s",amount,item)
    print(request)
    reccy = -1
    rednet.open("right")
    rednet.broadcast(request)
    while reccy ~= os.computerID() do
        s,m = rednet.receive(7.8)
        if s == nil then
            rednet.broadcast(request)
        else
            print(m)
            reccy = tonumber(string.sub(m,1,5))
        end
    end
    turtle.select(16)
    turtle.placeUp()
    i = 12
    while i > 2 do
      turtle.select(i)
      turtle.dropUp(64)
      i = i - 1
    end
    turtle.select(slotty)
    turtle.dropUp(64)
    turtle.suckUp(64)
    rednet.broadcast("END","dump_stop")
    turtle.select(14)
    turtle.equipRight()
    turtle.select(16)
    turtle.digUp()
    turtle.select(slotty)
end

function refuel()
    if turtle.getFuelLevel() < 6000 then
        item_RS_request("minecraft:coal",40,12)
        turtle.select(12)
        turtle.refuel(40)
    end
end

while w > 0 do
  d2 = d
  refuel()
  while d2 > 0 do
      if (math.mod(d2,4)-2) == 0 and (math.mod(w,4)-2) == 0 then
          slot = 2
      else
          slot = 1
      end
      if turtle.getItemCount(slot) < 4 then
        item_RS_request(items[slot],62-turtle.getItemCount(slot),slot)
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