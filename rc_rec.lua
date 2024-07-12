rednet.open("left")
broadcast_on_completion = false

function item_RS_request(item, amount, slotty)
    --turtle.select(14)
    --turtle.digUp()
    --turtle.equipRight()
    request = string.format("ITEM %04d %s",amount,item)
    print(request)
    reccy = -1
    --rednet.open("right")
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
    while not turtle.placeUp() do
        digUp()
    end
    i = 12
    if turtle.getItemCount(i) > 1 then
        while i > 2 do
        turtle.select(i)
        turtle.dropUp(64)
        i = i - 1
        end
    end
    turtle.select(slotty)
    turtle.dropUp(64)
    turtle.suckUp(64)
    rednet.broadcast("END","dump_stop")
    --turtle.select(14)
    --turtle.equipRight()
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

function dig()
    success, block = turtle.inspect()
    if block.name ~= "computercraft:turtle_advanced" and block.name ~= "computercraft:turtle_normal" then
        turtle.dig()
        turtle.attack()
    end
    refuel()
end

function digUp()
    success, block = turtle.inspectUp()
    if block.name ~= "computercraft:turtle_advanced" and block.name ~= "computercraft:turtle_normal" then
        turtle.digUp()
        turtle.attack()
    end
    refuel()
end

function digDown()
    success, block = turtle.digDown()
    if block.name ~= "computercraft:turtle_advanced" and block.name ~= "computercraft:turtle_normal" then
        turtle.digDown()
        turtle.attack()
    end
    refuel()
end

function command_complete()
	if broadcast_on_completion then
    	rednet.broadcast("COMPLETE","command_complete")
	end
end

while true do
    sender, message, distance = rednet.receive()
    turtle_id = string.sub(message,1,4)
    print(sender,message,distance,turtle_id)
    if turtle_id == "-001" or turtle_id == string.format("%04d",os.getComputerID()) then
        print("Executing command...")
        command = string.sub(message,6,10)
        if command == "ackno" then
            broadcast_on_completion = true
        elseif command == "noack" then
            broadcast_on_completion = false
        elseif command == "shell" then
            shell.run(string.sub(message,12))
        elseif command == "seek " or command == "fseek" then
            axis = string.sub(message,12,12)
            target = tonumber(string.sub(message,14))
            direction = 0
			refuel()
            for count = 1,4 do
				if turtle.forward() then
					fx, fy, fz = gps.locate()
					turtle.back()
					cx, cy, cz = gps.locate()
					if fx > cx then
						direction = 1
					elseif fx < cx then
						direction = 3
					elseif fz > cz then
						direction = 4
					elseif fz < cz then
						direction = 2
					end
					break
				else
					turtle.turnRight()
				end
				print(direction)
			end
            if direction == 0 then
				print(direction)
				for count = 1,4 do
					s,d = turtle.inspect()
					if d.name == "computercraft:turtle" or d.name == "computercraft:turtle_normal" or d.name == "computercraft:turtle_advanced" or d.name == "minecraft:chest" or d.name == "enderstorage:ender_storage" then
						turtle.turnRight()
						s,d = turtle.inspect()
					else
						while not turtle.forward() do
							turtle.dig()
						end
						fx, fy, fz = gps.locate()
						turtle.back()
						cx, cy, cz = gps.locate()
						direction = 0
						if fx > cx then
							direction = 1
						elseif fx < cx then
							direction = 3
						elseif fz > cz then
							direction = 4
						elseif fz < cz then
							direction = 2
						end
						break
					end
				end
			end
            axis = string.upper(axis)
			if axis == "X" then
				if target > cx then
					targetdir = 1
				else
					targetdir = 3
				end
				dist = math.abs(target - cx)
			end
			if axis == "Y" then
				targetdir = 1
				curr = cy
				dist = math.abs(target - cy)
			end
			if axis == "Z" then
				if target > cz then
					targetdir = 4
				else
					targetdir = 2
				end
				dist = math.abs(target - cz)
			end
			if axis == "D" then
				if target > 0 and target < 5 then
					targetdir = target
				end
			end
			while direction ~= targetdir do
				turtle.turnLeft()
				direction = direction + 1
				if direction == 5 then
					direction = 1
				end
			end
            if command == "fseek" then
                dig_enabled = true
            end
            curr = 0
            if axis == "X" or axis == "Z" then
                while curr < dist do
                    if dig_enabled then
                        dig()
                    end
                    if turtle.forward() then
                        curr = curr + 1
                    end
                end
            elseif axis == "Y" then
                while curr < dist do
                    if target > cy then
                        if dig_enabled then
                            digUp()
                        end
                        if turtle.up() then
                            curr = curr + 1
                        end
                    else
						if dig_enabled then
                            digDown()
                        end
                        if turtle.down() then
                            curr = curr + 1
                        end
					end
				end
			end
			print(direction,curr,cx,cy,cz)
        elseif command == "find " then
            sleep(0.2)
            x,y,z = gps.locate()
            if(x) then
				print(x,y,z)
                rednet.broadcast("turtle "..os.getComputerLabel().." "..os.getComputerID().." "..x.." "..y.." "..z)
            else
                rednet.broadcast("turtle "..os.getComputerLabel().." "..os.getComputerID().." ? ? ?")
            end
        elseif command == "fuel " then
            refuel()
		end
        command_complete()
	end
end




    