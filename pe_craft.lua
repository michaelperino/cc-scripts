storage = peripheral.find("rsBridge")
recipes = {}
curr_rec = "projecte:collector_mk1"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:glowstone"] = 2
recipes[curr_rec]["minecraft:diamond_block"] = 1
recipes[curr_rec]["minecraft:furnace"] = 1
recipes[curr_rec]["minecraft:glass"] = 1
recipes[curr_rec]["projecte:alchemical_chest"] = 1
curr_rec = "projecte:collector_mk2"
recipes[curr_rec] = {}
recipes[curr_rec]["minecraft:glowstone"] = 4
recipes[curr_rec]["projecte:dark_matter"] = 1
recipes[curr_rec]["projecte:collector_mk1"] = 1
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
        for k,v00 in pairs(recipes) do
            if k == chosen_rec then
                for k1,v in pairs(recipes[k]) do
                    item = storage.getItem({name=k1})
                    if item ~= nil then
                        if item.amount < v then
                            storage.craftItem({name=k1,count=v-item.amount})
                        end
                    end
                end
                valid = true
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
                        v_out,a = storage.exportItem({name=k1,count=v},"east")
                    end
                end
            end
        end
        while redstone.getInput("back") do
            sleep(0.03)
        end
        sleep(0.1)
        quantity = quantity - 1
    end
end