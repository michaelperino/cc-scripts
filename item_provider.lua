rednet.open("left")
storage = peripheral.find("rsBridge")
while true do
    s,m,p = rednet.receive()
    sleep(0.2)
    if string.len(m) > 6 and string.sub(m,1,4) == "ITEM" then
        num_req = tonumber(string.sub(m,6,10))
        print(num_req)
        item_req = {}
        item_req.name = string.sub(m,11)
        print(item_req.name)
        item_stor = storage.getItem(item_req)
        if item_stor ~= nil then
            redstone.setOutput("top",true)
            item_stor.count = num_req
            print(item_stor.amount)
            storage.craftItem({name=item_req.name,count=num_req})
            v,a = storage.exportItem({name=item_req.name,count=num_req},"up")
            rednet.broadcast(string.format("%04d %04d", s, v))
            s1,m1,p1 = rednet.receive("dump_stop",6.5)
            redstone.setOutput("top",false)
            sleep(0.1)
            --storage.importItem({name=item_req.name,count=64},"up")
        end
    end
end
    
    