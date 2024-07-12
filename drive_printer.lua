--ORIGIN
ox = 172
oy = 63
oz = 475
od = 1

peripheral.find("modem").open(os.getComputerID())

filename = "island1"
local h = fs.open(filename,"r")
line = h.readLine()
data_array = {}
i = 0

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
	line = h.readLine()
end

while true do
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
	print(side,channel,replyChannel,message.sProtocol,message.message,distance)
	s = replyChannel
	if message.sProtocol == "printer" then
		comm = string.sub(message.message,1,3)
		sleep(0.02)
		if comm == "ORI" then
			rednet.send(s,string.format("%6d,%6d,%6d,%6d",ox,oy,oz,od),"printer")
		end
		if comm == "DAT" then
			data = ParseCSVLine(m)
			reply = ""
			for i = 0,15 do
				reply = reply..tostring(data_array[data[2]-ox+1][data[4]-oz+1+i])..","
			end
			rednet.send(s,reply,"printer")
		end
	end
end
