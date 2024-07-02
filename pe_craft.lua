storage = peripheral.find("rsBridge")
recipes = {}
curr_rec = "projecte:condensor_mk1"
recipes[curr_rec] = {}
recipes[curr_rec]["projecte:dark_matter_block"] = 1
recipes[curr_rec]["projecte:red_matter_block"] = 1
recipes[curr_rec]["projecte:alchemical_chest"] = 1
recipes[curr_rec]["ironchest:dirt_chest"] = 1
recipes[curr_rec]["ironchest:crystal_chest"] = 1
curr_rec = "projecte:collector_mk1"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:glowstone"] = 2
recipes[curr_rec]["minecraft:diamond_block"] = 1
recipes[curr_rec]["minecraft:furnace"] = 1
recipes[curr_rec]["minecraft:glass"] = 1
recipes[curr_rec]["projecte:alchemical_chest"] = 1
curr_rec = "projecte:relay_mk1"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:obsidian"] = 2
recipes[curr_rec]["minecraft:diamond_block"] = 1
recipes[curr_rec]["minecraft:furnace"] = 1
recipes[curr_rec]["minecraft:glass"] = 1
recipes[curr_rec]["projecte:alchemical_chest"] = 1
curr_rec = "projecte:collector_mk2"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:glowstone"] = 4
recipes[curr_rec]["projecte:dark_matter"] = 1
recipes[curr_rec]["projecte:collector_mk1"] = 1
curr_rec = "projecte:relay_mk2"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:obsidian"] = 4
recipes[curr_rec]["projecte:dark_matter"] = 1
recipes[curr_rec]["projecte:relay_mk1"] = 1
curr_rec = "projecte:collector_mk3"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:glowstone"] = 4
recipes[curr_rec]["projecte:red_matter"] = 1
recipes[curr_rec]["projecte:collector_mk2"] = 1
curr_rec = "projecte:relay_mk3"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:obsidian"] = 4
recipes[curr_rec]["projecte:red_matter"] = 1
recipes[curr_rec]["projecte:relay_mk2"] = 1
curr_rec = "projecte:low_covalence_dust"
recipes[curr_rec] = {}
recipes[curr_rec]["ftbstoneblock:2x_compressed_cobblestone"] = 1
recipes[curr_rec]["minecraft:redstone"] = 4
curr_rec = "projecte:medium_covalence_dust"
recipes[curr_rec] = {}
recipes[curr_rec]["create:zinc_ingot"] = 1
recipes[curr_rec]["minecraft:redstone"] = 4
curr_rec = "projecte:high_covalence_dust"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:coal"] = 4
recipes[curr_rec]["minecraft:diamond"] = 1
curr_rec = "powah:steel_energized"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:iron_ingot"] = 1
recipes[curr_rec]["minecraft:gold_ingot"] = 1
curr_rec = "powah:crystal_blazing"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:blaze_rod"] = 1
curr_rec = "powah:crystal_niotic"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:diamond"] = 1
curr_rec = "powah:crystal_spirited"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:emerald"] = 1
curr_rec = "powah:nitro_crystal"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:nether_star"] = 1
recipes[curr_rec]["minecraft:redstone_block"] = 2
recipes[curr_rec]["minecraft:blazing_crystal_block"] = 1


all_items = {}
MAX_C = 1
for k,v in pairs(recipes) do
    all_items[MAX_C] = k
    MAX_C = MAX_C + 1
end

while true do
    for k,v in pairs(all_items) do
        print(string.format("%d : %s",k,v))
    end
    chosen_rec = tonumber(read())
    chosen_rec = all_items[chosen_rec]
    print("quantity?")
    quantity = tonumber(read())
    while quantity > 0 do
        valid = true
        for k,v00 in pairs(recipes) do
            if k == chosen_rec then
                for k1,v in pairs(recipes[k]) do
                    item = storage.getItem({name=k1})
                    if item ~= nil then
                        if item.amount < v then
                            storage.craftItem({name=k1,count=v-item.amount})
                        elseif v == 1 then
                            storage.craftItem({name=k1,count=1})
                        end
                    end
                end
                for k1,v in pairs(recipes[k]) do
                    item = storage.getItem({name=k1})
                    if item == nil then
                        print(string.format("ITEM MISSING: %s, NEED %d", k1, v))
                        valid = false
                    elseif storage.getItem({name=k1}).amount < v then
                        print(string.format("MISSING SOME %s, ONLY HAVE %d of %d",k1,storage.getItem({name=k1}).amount,v))
                        valid = false
                    end
                end
                if valid then
                    for k1,v in pairs(recipes[k]) do
                        --[[temp_to_export = v
                        while temp_to_export > 0 do
                            v,a = storage.exportItem({name=k1,count=1},"east")
                            temp_to_export = temp_to_export - 1
                        end]]--
                        total_out = 0
                        v_out,a = storage.exportItem({name=k1,count=v},"east")
                        total_out = v_out
                        if total_out ~= v then
                            print("ITEM ERROR, ATTEMPTING TO EXPORT, PLEASE GO PUT THE ITEM IN AS NEEDED")
                            print(string.format("%s %d INSERTED OF %d",k1,total_out,v))
                            while total_out < v do
                                v_out,a = storage.exportItem({name=k1,count=v - total_out},"east")
                                total_out = total_out + v_out
                                sleep(1)
                            end
                        end
                    end
                end
            end
        end
        if valid then
            while redstone.getInput("back") do
                sleep(0.03)
            end
            sleep(0.25)
        else
            sleep(5)
        end
        quantity = quantity - 1
    end
end