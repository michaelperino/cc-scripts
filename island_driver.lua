rednet.open("back")
f = fs.open("LOG_FILE","a")
turtles = {}
i = 0
rednet.broadcast("-001 ackno")
s = 7000
while s do
    s,m = rednet.receive("command_complete",5)
    if s ~= nil then
        i = i + 1
        turtles[i] = s
    end
end
num_turtles = i
print(num_turtles)
curr_chunk_x = 0
curr_chunk_z = 0
for i = 1,num_turtles do
    rednet.broadcast(string.format("%04d shell printer.lua %d %d",turtles[i],curr_chunk_x,curr_chunk_z))
    f.write(string.format("%d %d started by %d\n",curr_chunk_x,curr_chunk_z,turtles[i]))
    f.flush()
    curr_chunk_z = curr_chunk_z + 1
    if curr_chunk_z == 8 then
        curr_chunk_z = 0
        curr_chunk_x = curr_chunk_x + 1
    end
    sleep(10)
end
while curr_chunk_x < 8 do
    s,m = rednet.receive("command_complete")
    sleep(0.1)
    rednet.broadcast(string.format("%04d shell printer.lua %d %d",s,curr_chunk_x,curr_chunk_z))
    f.write(string.format("%d %d started by %d\n",curr_chunk_x,curr_chunk_z,turtles[i]))
    f.flush()
    curr_chunk_z = curr_chunk_z + 1
    if curr_chunk_z == 8 then
        curr_chunk_z = 0
        curr_chunk_x = curr_chunk_x + 1
    end
end