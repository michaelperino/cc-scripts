p = peripheral.find("rsBridge")
recipes = {}
curr_rec = "projecte:collector_mk1"
recipes[curr_rec] = []
recipes[curr_rec]["minecraft:glowstone"] = 2
recipes[curr_rec]["minecraft:diamond_block"] = 1
recipes[curr_rec]["minecraft:furnace"] = 1
recipes[curr_rec]["minecraft:glass"] = 1
recipes[curr_rec]["projecte:alchemcial_chest"] = 1
curr_rec = "projecte:collector_mk2"
recipes[curr_rec] = []
recipes[curr_rec]["minecraft:glowstone"] = 4
recipes[curr_rec]["minecraft:diamond_block"] = 1
recipes[curr_rec]["projecte:dark_matter"] = 1
recipes[curr_rec]["projecte:collector_mk1"] = 1


while true do
    chosen_rec = input()
    for k,v00 in pairs(recipes) do
        if k == chosen_rec do
            for k1,v in pairs(recipes[k]) do
                storage.craftItem({name=k1,count=v})
            end
            sleep(5)
            for k1,v in pairs(recipes[k]) do
                if storage.getItem({name=k1}).amount < v then
                    print("MISSING %s, ONLY HAVE %d of %d",k,storage.getItem({name=k1}).amount,v)
                end
            end
            for k1,v in pairs(recipes[k]) do
                v,a = storage.exportItem({name=k1,count=v},"east")
            end
        end
    end
end