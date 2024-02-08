
seedID = 3
blockID = 2
depoWorld = "EXAMPLE" -- Write it with big letter
depoWorldID = "EXAMPLE" -- Write it with big letter

WebhookUrl = ""

--[Define]--
bot = getBot()
farm = getBot().auto_farm
transfer = getBot().auto_transfer 

function getInterval()
   return getBot():getPing() + math.random(20,50)
end

function getItemCount(itemID)
    return getBot():getInventory():getItemCount(itemID)
end
function checkNuked(varlist,netid)
    if varlist:get(0):getString() == "OnConsoleMessage" and varlist:get(1):getString():find("inaccessible") then
        nuked = true
    end
end

addEvent(Event.variantlist,checkNuked)

function GonWebhook(desc,itemID)
    wh = Webhook.new(WebhookUrl)
    wh.username = "Chaos Automation"
    wh.avatar_url = "https://hotpotmedia.s3.us-east-2.amazonaws.com/8-tMAtY6FgnVINsJa.png?nc=1"
    wh.embed1.title = "Pabric " .. getInfo(itemID).name .. " <:nuke:960435561968042054>" 
    wh.embed1.use = true
    wh.embed1.description = desc
    wh.embed1.color = 0xFF0000 
    wh:send()
end

function growScan(itemID)
    return (getBot():getWorld().growscan:getObjects()[itemID]) or 0
end

function Warp(world, id)
    local warpCount = 0

    while getBot():getWorld().name ~= world:upper() do
        if getBot().status ~= 1 then
            break
        end

        warpCount = warpCount + 1
        if warpCount >= 5 then
            getBot():disconnect()
            warpCount = 0
            sleep(math.random(15000,30000))
        end

        if getBot().status == 1 then
            getBot():warp(world)
            print(getBot().name .. " warped to " .. world)
            listenEvents(6)
            if nuked == true then
                GonWebhook(world:upper().." is nuked")
                break
            end
        end
    end

    if id then
        if getBot():getWorld().name == world:upper() then
            warpCount = 0
            getBot():warp(world, id)
            print(getBot().name .. " warped to id : " .. id)
            sleep(math.random(4513, 6102))
        end
    end
    nuked = false
end

function Collect(boolean,range,interval)
    bot.auto_collect = boolean
    bot.collect_range = range
    bot.collect_interval = interval
end

function findPathToLabel(label)
    for _, tile in pairs(getBot():getWorld():getTiles()) do
        if tile.fg == signID then
            if tile:getExtra().label == label then
                if getBot():isInTile(tile.x,tile.y) then
                    break
                end
                if not getBot():isInTile(tile.x,tile.y) then
                    if #getBot():getPath(tile.x,tile.y) > 0 then
                    getBot():findPath(tile.x,tile.y)
                    sleep(1000)
                    end
                end
            end
        end
    end
    sleep(1000)
end

function dropItem(itemID,count,worldName)
    if not getBot():isInWorld(worldName) then
        Warp(worldName,depoWorldID)
    end
    if getItemCount(itemID) >= count and getBot().status == 1 then
        Collect(false,4,200)
		getBot():setDirection(right)
		sleep(1000)
        getBot():drop(itemID,count)
        sleep(1000)
        while getItemCount(itemID) >= count and getBot().status == 1 do
            getBot():setDirection(right)
            sleep(300)
            getBot():moveRight()
            sleep(300)
            getBot():drop(itemID,count)
            sleep(1000)
        end
    end
    sleep(1000)
end

function setFarm(rangemin,rangemax,increaseRate)
    for i = rangemin , rangemax,increaseRate do
        farm:setActive(i, true)
        farm.auto_place = true
        farm.auto_break = true
    end
end

function setPos(x,y)
    if getBot():isInWorld() then
        if not getBot():isInTile(x,y) then
            getBot():findPath(x,y)
            sleep(1000)
        end
    end
end

function returnOnlineBotCount()
    local count = 0
    for _, bot in pairs(getBots()) do
        if bot.status == 1 then
            count = count + 1
        end
    end
    return count
end

function breakBlock(itemID,seedID,depoName,worldName)
    if not getBot():isInWorld(worldName) then
        Warp(worldName)
    end
    setFarm(0,20,5)
    Collect(true,4,200)
    farm.id = itemID
    while getItemCount(itemID) > 0 and getBot().status == 1 do
    while not getBot():isInTile(53,17) and getBot():isInWorld(worldName:upper()) do
        setPos(53,17)
    end
        sleep(5000)
        if farm.enabled == false then
            farm.enabled = true
        end
        if getItemCount(seedID) >= 200 then
            farm.enabled = false
            Collect(false,4,200)
            dropItem(seedID,101,depoName)
            GonWebhook(getInfo(seedID).name.. " count is : " .. growScan(seedID).. "\nBots Online: "  .. returnOnlineBotCount().. "\ncurrent world name is " .. getBot():getWorld().name:upper(),seedID)
            if not getBot():isInWorld(worldName) then
                Warp(worldName)
            end
            if getItemCount(itemID) > 0 then
                if not getBot():isInWorld(worldName:upper()) then
                    Warp(worldName:upper())
                end
                while not  getBot():isInTile(53,17) and getBot():isInWorld(worldName:upper()) do
                    setPos(53,17)
                end
                setPos(53,17)
                if farm.enabled == false then
                    farm.enabled = true
					Collect(true,4,200)
                end
            end
        end
    end
end

function takeItemFromStorage(itemID,depoWorld)
    Collect(false,2,200)
    if not getBot():isInWorld(depoWorld) then
        Warp(depoWorld,depoWorldID)
    end
    if getBot():isInWorld(depoWorld) then
        for _, obj in pairs(getObjects()) do
            if obj.id == itemID then
                if getItemCount(itemID) > 199 then 
                    break
                end
                getBot():findPath(math.floor(obj.x/32),math.floor(obj.y/32))
                getBot():collectObject(obj.oid,3)
                sleep(1000)
            end
        end
    end
end

function takeItemFromStorage2(itemID,depoWorld,count)
    Collect(false,2,200)
    if not getBot():isInWorld(depoWorld) then
        Warp(depoWorld,depoWorldID)
    end
    if getBot():isInWorld(depoWorld) then
        for _, obj in pairs(getObjects()) do
            if obj.id == itemID then
                if getItemCount(itemID) >= count then 
                    break
                end
                getBot():findPath(math.floor(obj.x/32),math.floor(obj.y/32))
                getBot():collectObject(obj.oid,3)
                sleep(1000)
                while getItemCount(itemID) > count do
                    getBot():drop(itemID,getItemCount(itemID)-count)
                    sleep(1000)
                end
            end
        end
    end
end

function plantSeed(seedID,worldName)
    if farm.enabled == true then
    farm.enabled = false
    sleep(100)
    end
    if not getBot():isInWorld(worldName) then
        Warp(worldName)
    end
    if getItemCount(seedID) > 0 and getBot():isInWorld(worldName) and getBot().status == 1  then
        for _, tile in pairs(getBot():getWorld():getTiles()) do
            if tile.y > 24 and tile.fg == 0 and getBot().status == 1 and getItemCount(seedID) > 0 and getTile(tile.x,tile.y + 1).fg ~= 0 and tile.y < 28 then
                getBot():findPath(tile.x,tile.y)
                if getItemCount(seedID) > 0 and getBot():isInTile(tile.x,tile.y) then
                getBot():place(getBot().x,getBot().y,seedID)
                sleep(getInterval())
                end
            end
        end
    end
end

function returnFarmName()
    local farmName = read(getBot().name..".txt")
    if farmName == "" then
        write(getBot().name..".txt",getBot().name.. "" .. math.random(15,125))
        farmName = read(getBot().name..".txt")
        return farmName
    end
    return farmName
end

function hitUntil(posX,posY,hitX,hitY)
    if getBot():isInTile(posX,posY) and getBot().status == 1 then 
        while (getTile(hitX,hitY).fg ~= 0 or getTile(hitX,hitY).bg ~= 0) and getBot().status == 1 do
            if getBot():isInTile(posX,posY) then
            getBot():hit(hitX,hitY)
            sleep(getInterval())
            getBot():collect(2,200)
            else
                break
            end
        end
    end
end

function isLocked()
    for _, tile in pairs(getTiles()) do
        if tile.fg == 242 and getBot():getWorld():hasAccess(tile.x,tile.y) == 1 then
            return true
        end
    end
    return false
end

function harvestSeed(seedID,worldName,depoName)
    if farm.enabled == true then
       farm.enabled = false
       sleep(100)
    end
    if not getBot():isInWorld(worldName) then
        Warp(worldName)
    end
    if getBot().status == 1 and getBot():isInWorld(worldName) then
        if not getBot():isInWorld(worldName) then
            Warp(worldName)
        end
        for _, tile in pairs(getBot():getWorld():getTiles()) do
            if tile.y > 23 and tile.fg == seedID and getBot().status == 1 and tile:canHarvest() == true then
                if getItemCount(seedID) >= 200 then
                    if farm.enabled == true then
                        farm.enabled = false
                        sleep(100)
                    end
                    dropItem(seedID,101,depoName)
                    sleep(1000)
                end
                if getItemCount(seedID - 1) >= 180 then
                    breakBlock(seedID-1,seedID,depoName,worldName)
                end
                if farm.enabled == true then
                    farm.enabled = false
                    sleep(100)
                end
                getBot():findPath(tile.x,tile.y)
                if getBot():isInTile(tile.x,tile.y) then
                    if getBot().auto_collect == false then
                    Collect(true,2,200)
                    end
                    getBot():hit(getBot().x,getBot().y)
                    sleep(getInterval())
                end
            end
        end
    end
end

function checkIsFarmDone(worldName,depoName)
    print("Checking farm status")
    if not getBot():isInWorld(worldName) then
        Warp(worldName)
    end
    if isLocked() == false then
        takeItemFromStorage2(242,depoWorld,1)
    end
    if not getBot():isInWorld(worldName) then
        Warp(worldName)
    end
    while isLocked() == false do
        getBot():place(getBot().x + 1,getBot().y-1,242)
        sleep(1000)
        getBot().auto_ban = true
    end
    if getBot().status == 1 and getBot():isInWorld(worldName) then
        if isLocked() == false then
            takeItemFromStorage2(242,depoWorld,1)
        end
        if not getBot():isInWorld(worldName) then
            Warp(worldName)
        end
        while isLocked() == false do
            getBot():place(getBot().x + 1,getBot().y-1,242)
            sleep(1000)
            getBot().auto_ban = true
        end
        for dirtY = 1,25 do
            if getTile(0,dirtY).fg == 2 or getTile(0,dirtY).bg == 14 then
                print("Block krilmasi lazim")
                getBot():findPath(0,dirtY - 1)
                hitUntil(0,dirtY - 1,0,dirtY)
                if getItemCount(3) >= 200 then
                    if farm.enabled == true then
                        farm.enabled = false
                        sleep(100)
                    end
                    dropItem(3,200,depoName)
                    sleep(1000)
                end
                if getItemCount(15) >= 200 then
                    if farm.enabled == true then
                        farm.enabled = false
                        sleep(100)
                    end
                    dropItem(15,200,depoName)
                    sleep(1000)
                end
            end
        end
        for dirtY = 1,25 do
            if getTile(99,dirtY).fg == 2 or getTile(99,dirtY).bg == 14 then
                getBot():findPath(99,dirtY - 1)
                hitUntil(99,dirtY - 1,99,dirtY)
                if getItemCount(3) >= 200 then
                    if farm.enabled == true then
                        farm.enabled = false
                        sleep(100)
                    end
                    dropItem(3,200,depoName)
                    sleep(1000)
                end
                if getItemCount(15) >= 200 then
                    if farm.enabled == true then
                        farm.enabled = false
                        sleep(100)
                    end
                    dropItem(15,200,depoName)
                    sleep(1000)
                end
            end
        end
        for dirtY = 1,25,2 do
            for dirtX = 1,99 do
                if getTile(dirtX,dirtY).fg == 2 or getTile(dirtX,dirtY).bg == 14 then
                    getBot():findPath(dirtX - 1,dirtY)
                    getBot():collect(2,200)
                    hitUntil(dirtX - 1,dirtY,dirtX,dirtY)
                    if getItemCount(3) >= 200 then
                        if farm.enabled == true then
                            farm.enabled = false
                            sleep(100)
                        end
                        dropItem(3,200,depoName)
                        sleep(1000)
                    end
                    if getItemCount(15) >= 200 then
                        if farm.enabled == true then
                            farm.enabled = false
                            sleep(100)
                        end
                        dropItem(15,200,depoName)
                        sleep(1000)
                    end
                end
            end
        end
        Collect(false,2,200)
    end
end

function farmItem(seedID,itemID,depoName,worldName)
    if getBot().status == 1 then
        if not getBot():isInWorld(worldName) then
            Warp(worldName)
        end
        while getBot():isInWorld(worldName) and getBot().status == 1 do 
        harvestSeed(seedID,worldName,depoName)
            if not getBot():isInWorld(worldName) then
                Warp(worldName)
            end
            breakBlock(itemID,seedID,depoName,worldName)
            if not getBot():isInWorld(worldName) then
                Warp(worldName)
            end
            plantSeed(seedID,worldName)
            if not getBot():isInWorld(worldName) then
                Warp(worldName)
            end
        end
    end
end

while true do
    farmName = returnFarmName()
    while getItemCount(seedID) < 20 do
    takeItemFromStorage2(seedID,depoWorld,20)
    end
    checkIsFarmDone(farmName:upper(),depoWorld:upper())
    farmItem(seedID,blockID,depoWorld:upper(),farmName:upper())
    sleep(1000)
end

