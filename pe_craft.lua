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
recipes[curr_rec]["minecraft:diamond_block"] = 1
recipes[curr_rec]["projecte:dark_matter"] = 1
recipes[curr_rec]["projecte:collector_mk1"] = 1

all_items = {}
MAX_C = 1
for k,v in pairs(recipes) do
    all_items[MAX_C] = k
    MAX_C = MAX_C + 1
end

while true do
    for k,v in pairs(all_items) do
        print(string.formate("%d : %s",k,v))
    end
    chosen_rec = tonumber(read())
    chosen_rec = all_items[chosen_rec]
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
            sleep(5)
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
                    v,a = storage.exportItem({name=k1,count=v},"east")
                end
            end
        end
    end
end