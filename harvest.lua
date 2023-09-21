---[Settings]---
delay = 400 -- Harvest
blockId = 2-- Block ID
seedId = 3 -- Seed ID
--------
worldsafe = "" -- storage world
safeDoorID = "" 
----
doorId =  -- Door id, should be the same for storage and plant worlds
worldList = {}
-----------
depoblock = 6388 -- Depo bloock id background for dropping blocks
WebhookUrl = "https://discord.com/api/webhooks/1151136282660061284/9A6nexJT09TdJnuixfJZg_69o5xsVbrilC7dC6FkhkGKwKw2B0E6LshQ94fc30ZAFCc3"
moonList = {10140, 10142, 10146, 10150, 10158, 10164, 10228, 11286, 12386, 1098, 1828 , 3870 , 7058 , 10134, 10136 , 10138 }
---Don't change anything here---
bot = getBot()
function Collect(truefalse,range,interval)
  bot.auto_collect = truefalse
  bot.collect_range = range
  bot.collect_interval = interval
end

function GonWebhook(desc)
  wh = Webhook.new(WebhookUrl)
  wh.username = "CHAOS BOT"
  wh.avatar_url = "https://hotpotmedia.s3.us-east-2.amazonaws.com/8-tMAtY6FgnVINsJa.png?nc=1"
  wh.embed1.use = true
  wh.embed1.title = "Auto Harvest"
  wh.embed1.description = desc
  wh.embed1.color = 0xFF0000 
  wh:send()
end

function punch(xOffset, yOffset)
    local player = getBot():getWorld():getLocal()
    local x = math.floor(player.posx / 32) + xOffset
    local y = math.floor(player.posy / 32) + yOffset
    getBot():hit(x, y)
end

function findPathToID(id)
    for _, tile in pairs(bot:getWorld():getTiles()) do
        if tile.bg == id then
            bot:findPath(tile.x,tile.y)
            sleep(1000)
        end
    end
end

function warps(world,id)
    while getBot():getWorld().name ~= world:upper() do
        getBot():warp(world)
        sleep(6000)
    end
    if getBot():getWorld().name == world:upper() then
        getBot():warp(world,id)
        sleep(3000)
    end
end

function dropp(id,id2)
        Collect(false,5,200)
        findPathToID(depoblock)
        sleep(1000)
        bot:drop(id,200)
        sleep(1000)
    while bot:getInventory():getItemCount(id) > 1 do
        bot:moveLeft()
        sleep(1000)
        bot:drop(id,200)
        sleep(1000)
    end
        bot:moveUp()
        sleep(1000)
        bot:drop(id2,200)
        sleep(1000)
    while bot:getInventory():getItemCount(id2) > 1 do
        bot:moveLeft()
        sleep(1000)
        bot:drop(id2,200)
        sleep(1000)
    end
        bot:moveUp()
    for _, things in pairs(moonList) do
if bot:getInventory():getItemCount(things) > 1 then
        bot:drop(things,200)
        sleep(1000)
        while bot:getInventory():getItemCount(things) > 1 do
        bot:moveLeft()
        sleep(1000)
        bot:drop(things,200)
        sleep(1000)
        end
    end
end
end


function harvest(id,id2,world)
  for _,tile in pairs(getTiles()) do
    if tile.fg ~= 0 and tile.fg == id2 then
      getBot():findPath(tile.x,tile.y)  
      sleep(delay)
      punch(0,0)
      Collect(true,4,200)
      if bot:getInventory():getItemCount(id) >= 180 or bot:getInventory():getItemCount(id2) >= 190 then
        getBot():warp(worldsafe,safeDoorID)
        sleep(3000)
        dropp(id,id2)
        warps(world,doorId)
        sleep(1700)
      end
    end
  end
end


while true do
  for _, world in pairs(worldList) do
    warps(world,doorId)

    sleep(100)
    harvest(blockId,seedId,world)
    GonWebhook("World: "..bot:getWorld().name.. " Done")
  end
	getBot():disconnect()
	getBot().auto_reconnect = false
	GonWebhook("BOT DISCONNECTED BECAUSE WORLDS FINISHED")
    sleep(1000000000)
end
