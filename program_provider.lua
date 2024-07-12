rednet.open("left")
s,m = rednet.receive("program_update",30)
while s ~= nil do
    if fs.exists(m) then
        h = fs.open(m)
        content = h.readAll()
        rednet.send(s,content,"program_update")
    end
    s,m = rednet.receive("program_update",30)
end