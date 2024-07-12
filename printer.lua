local args = {...}
offset_x_chunk = args[1]
offset_z_chunk = args[2]

base_ID = 10

rednet.open("left")
broadcast_on_completion = false

function ParseCSVLine (line,sep) 
	local res = {}
	local pos = 1
	sep = sep or ','
	while true do 
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '"') then
			-- quoted value (ignore separator within)
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos) 
				if (c == '"') then txt = txt..'"' end 
				-- check first char AFTER quoted string, if it is another
				-- quoted string without separator, then append it
				-- this is the way to "escape" the quote char in a quote. example:
				--   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
			until (c ~= '"')
			table.insert(res,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else	
			-- no quotes used, just look for the first separator
			local startp,endp = string.find(line,sep,pos)
			if (startp) then 
				table.insert(res,string.sub(line,pos,startp-1))
				pos = endp + 1
			else
				-- no separator found -> use rest of string and terminate
				table.insert(res,string.sub(line,pos))
				break
			end 
		end
	end
	return res
end

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


function traverse(gx,gy,gz,gd)
    refuel()
    axis = string.sub(message,12,12)
    target = tonumber(string.sub(message,14))
    direction = 0
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
    axes = {X=gx,Y=gy,Z=gz,D=gd}
    for k,v in pairs(axes) do
        axis = string.upper(k)
        target = v
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
        dig_enabled = true
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
    end
end

m = nil
while m == nil do
    rednet.send(base_ID,"ORI","printer")
    s,m = rednet.receive("printer",10)
end
data = ParseCSVLine(m,",")
ox = data[1]
oy = data[2]
oz = data[3]
od = data[4]
slot = 1
m = nil
for curr_z_offset = 0,15 do
    traverse(ox+offset_x_chunk*16,oy,oz+curr_z_offset*16)
    while m == nil do
        rednet.send(base_ID,string.format("DAT,%06d,%06d,%06d"))
        s,m = rednet.receive("printer",10)
    end
    data = ParseCSVLine(m,",")
    curr_y = oy
    for curr_x_offset = 0,15 do
        if turtle.getItemCount(slot) < 4 then
            item_RS_request("minecraft:dirt",62-turtle.getItemCount(slot),slot)
        end
        while turtle.forward() == false do
            dig()
        end
        target = data[curr_x_offset+2]
        if target < curr_y then
            while turtle.down() == false do
                digDown()
            end
            curr_y = curr_y - 1
        end
        if target > curr_y then
            while turtle.up() == false do
                digUp()
            end
            curr_y = curr_y + 1
        end
        turtle.placeDown()
    end
end
