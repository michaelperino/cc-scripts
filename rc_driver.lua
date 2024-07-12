peripheral.find("modem").open(os.getComputerID)
peripheral.find("modem").open(65535)
while true do
    print("Ender command or computer ID\n")
    command = read()
    id = -001
    if tonumber(command) then
        id = tonumber(command)
        print("Enter command for turtle ",string.format("%4d",os.getComputerID()),"\n")
        command = read()
    end
    if command == "shell" then
        print("Enter verbatim command\n")
        arg1 = read()
        rednet.broadcast(id.." "..command.." "..arg1)
    elseif command == "seek" or command == "seek " or command =="fseek" then
        if string.len(command) == 4 then
            command = command.." "
        end
        print("Which axis?\n")
        axis = read()
        print("where on axis?\n")
        value = read()
        target = string.format("%6d",value)
        if coordinate == "x" or coordinate == "X" then
            rednet.broadcast(id.." "..command.." ".."X".." "..target)
        elseif coordinate == "y" or coordinate == "Y" then
            rednet.broadcast(id.." "..command.." ".."Y".." "..target)
        elseif coordinate == "z" or coordinate == "Z" then
            rednet.broadcast(id.." "..command.." ".."Z".." "..target)
        end
    elseif command == "find" or command == "find " then
        print("Press q to stop receiving\n")
        local event, key, isHeld = os.pullEvent("key")
        while key ~= keys.q do
            success,message = rednet.receive(2)
            if success then
                print(message)
            end
        end
    elseif command == "ackno" or command == "noack" then
        rednet.broadcast(id.." "..command)
    end
end
        
