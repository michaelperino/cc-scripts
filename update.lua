local args = {...}
program = args[1]

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

if program == "all" then
    for k,v in pairs(programs) do
        shell.run("delete "..k)
        shell.run("wget "..v)
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
