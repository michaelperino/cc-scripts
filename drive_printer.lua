--ORIGIN
ox = 176
oy = 63
oz = 480
od = 1

rednet.open("left")
MY_ID = 50001
peripheral.find("modem").open(MY_ID)

filename = "island1"
local h = fs.open(filename,"r")
line = h.readLine()
data_array = {}
i = 1

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

while line ~= nil do
    data_array[i] = ParseCSVLine(line,",")
	i = i + 1
	line = h.readLine()
end

valid_Ys = {}
turtle_Ys = {}
for i = 0,100 do
	valid_Ys[i] = i
end

function generateSquareData(x,z,size_x,size_z)
	block = {}
	for i = 1,size_z do
		block[i] = {}
		for j = 1,size_x do
			block[i][j] = data_array[z-oz+1+i][x-ox+1+j]
		end
	end
	return block
end


while true do
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
	print(side,channel,replyChannel,message.sProtocol,message.message,distance)
	s = replyChannel
	m = message.message
	if message.sProtocol == "printer" then
		comm = string.sub(m,1,3)
		sleep(0.02)
		if comm == "ORI" then
			rednet.send(s,string.format("%6d,%6d,%6d,%6d",ox,oy,oz,od),"printer")
		end
		if comm == "DAT" then
			data = ParseCSVLine(m)
			reply = ""
			for i = 0,18 do
				print(data[4]-oz+1,data[2]-ox+1+i)
				if data_array[data[2]-ox+1] == nil then
					break
				end
				reply = reply..tostring(data_array[data[4]-oz+1][data[2]-ox+1+i])..","
			end
			rednet.send(s,reply,"printer")
		end
		if comm == "SQU" then
			data = ParseCSVLine(m)
			reply = generateSquareData(data[2],data[4],data[6],data[7])
			rednet.send(s,reply,"printer")
		end
		if comm == "SEY" then
			minny = 128
			keyny = nil
			for key,val in pairs(valid_Ys) do
				if minny < val then
					minny = val
					keyny = key
				end
			end
			if keyny ~= nil then
				valid_Ys[keyny] = nil
			else
				minny = math.random(1,20)
			end
			turtle_Ys[s] = minny
			rednet.send(s,string.format("%6d",minny),"printer")
		end
		if comm == "REY" then
			if turtle_Ys[s] ~= nil then
				valid_Ys[turtle_Ys[s]] = turtle_Ys[s]
				turtle_Ys[s] = nil
			end
		end
	end
end
