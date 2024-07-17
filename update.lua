local args = {...}
program = args[1]
local_up = args[2]

programs = {}
programs["floorer.lua"] = "https://raw.githubusercontent.com/michaelperino/cc-scripts/master/floorer.lua"
programs["item_provider.lua"] = "https://raw.githubusercontent.com/michaelperino/cc-scripts/master/item_provider.lua"
programs["update.lua"] = "https://raw.githubusercontent.com/michaelperino/cc-scripts/master/update.lua"
programs["pe_craft.lua"] = "https://raw.githubusercontent.com/michaelperino/cc-scripts/master/pe_craft.lua"
programs["rc_rec.lua"] = "https://raw.githubusercontent.com/michaelperino/cc-scripts/master/rc_rec.lua"
programs["rc_driver.lua"] = "https://raw.githubusercontent.com/michaelperino/cc-scripts/master/rc_driver.lua"
programs["printer.lua"] = "https://raw.githubusercontent.com/michaelperino/cc-scripts/master/printer.lua"
programs["drive_printer.lua"] = "https://raw.githubusercontent.com/michaelperino/cc-scripts/master/drive_printer.lua"
programs["island_driver.lua"] = "https://raw.githubusercontent.com/michaelperino/cc-scripts/master/island_driver.lua"
programs["program_provider.lua"] = "https://raw.githubusercontent.com/michaelperino/cc-scripts/master/program_provider.lua"
programs["torcher.lua"] = "https://raw.githubusercontent.com/michaelperino/cc-scripts/master/torcher.lua"

if program == "all" then
    for k,v in pairs(programs) do
        if local_up ~= nil then
            rednet.open("left")
            sleep(math.random(50,500)/100)
            rednet.broadcast(k,"program_update")
            s,m = rednet.receive("program_file",10)
            if m ~= nil then   
                shell.run("delete "..k)
                h = fs.open(k,"w")
                h.write(m)
            end
        else
            shell.run("delete "..k)
            shell.run("wget "..v)
        end
    end
elseif local_up ~= nil then
    rednet.open("left")
    sleep(math.random(50,500)/100)
    rednet.broadcast(program,"program_update")
    s,m = rednet.receive("program_file",10)
    if m ~= nil then   
        shell.run("delete "..program)
        h = fs.open(program,"w")
        h.write(m)
    end
else
    shell.run("delete "..program)
    shell.run("wget "..programs[program])
end
--[[shell.run("delete floorer.lua")
shell.run("delete item_provider.lua")
shell.run("delete update.lua")
shell.run("delete pe_craft.lua")
shell.run("delete rc_rec.lua")
shell.run("delete rc_driver.lua")

shell.run("wget https://raw.githubusercontent.com/michaelperino/cc-scripts/master/update.lua")
shell.run("wget https://raw.githubusercontent.com/michaelperino/cc-scripts/master/floorer.lua")
shell.run("wget https://raw.githubusercontent.com/michaelperino/cc-scripts/master/item_provider.lua")
shell.run("wget https://raw.githubusercontent.com/michaelperino/cc-scripts/master/pe_craft.lua")
shell.run("wget https://raw.githubusercontent.com/michaelperino/cc-scripts/master/rc_rec.lua")
shell.run("wget https://raw.githubusercontent.com/michaelperino/cc-scripts/master/rc_driver.lua")]]--
