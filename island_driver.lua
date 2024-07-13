curr_chunk_x = 0
curr_chunk_z = 16
z_rollover = 0
z_max = 32
max_x = 16
rednet.open("left")
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
all_chunks = {}
num_chunks = max_x * max_z
for i = curr_chunk_x,max_x do
    for j = curr_chunk_z,max_z do
        table.insert(all_chunks,{x=curr_chunk_x,z=curr_chunk_z})
    end
end
for i = #all_chunks, 2, -1 do
    local j = math.random(i)
    all_chunks[i], all_chunks[j] = all_chunks[j], all_chunks[i]
end

chunk_idx = 1

for i = 1,num_turtles do
    curr_chunk = all_chunks[chunk_idx]
    chunk_idx = chunk_idx + 1
    rednet.broadcast(string.format("%04d shell printer.lua %d %d",turtles[i],curr_chunk["x"],curr_chunk["z"]))
    f.write(string.format("%d %d started by %d\n",curr_chunk["x"],curr_chunk["z"],turtles[i]))
    f.flush()
    sleep(0.5)
end
while chunk_idx <= num_chunks do
    s,m = rednet.receive("command_complete")
    f.write(string.format("Comm Complete %d",s))
    sleep(0.1)
    curr_chunk = all_chunks[chunk_idx]
    chunk_idx = chunk_idx + 1
    rednet.broadcast(string.format("%04d shell printer.lua %d %d",turtles[i],curr_chunk["x"],curr_chunk["z"]))
    f.write(string.format("%d %d started by %d\n",curr_chunk["x"],curr_chunk["z"],turtles[i]))
    f.flush()
end
