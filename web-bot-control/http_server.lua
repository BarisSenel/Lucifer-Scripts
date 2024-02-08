server = HttpServer.new()


server:get("/", function(request, response)
  local file_path = "C:\\Users\\ev\\Desktop\\websiteForBots\\index.html" --Change this to where your html file located
  local file_content = io.open(file_path, "r"):read("*a")

  response:setContent(file_content, "text/html")
end)
-- API endpoint for getting bot statuses
server:get("/bot/get_bots", function(request, response)
  local is_valid_key = request:getParam("secret") == "ilovebots"
  
  if is_valid_key then
    local bot_info = {}

    -- Iterate through all bots and collect names, statuses, levels, and current worlds
    for _, bot in pairs(getBots()) do
      local status_string
      if bot.status == 0 then
        status_string = "Offline"
      elseif bot.status == 1 then
        status_string = "Online"
      elseif bot.status == 2 then
        status_string = "Wrong Password"
      elseif bot.status == 3 then
        status_string = "Account Banned"
      elseif bot.status == 4 then
        status_string = "Location Banned"
      elseif bot.status == 5 then
        status_string = "Version Update"
      elseif bot.status == 6 then
        status_string = "AAP"
      elseif bot.status == 7 then
        status_string = "Server Overload"
      elseif bot.status == 8 then
        status_string = "Too many login"
      elseif bot.status == 9 then
        status_string = "Maintenance"
      elseif bot.status == 10 then
        status_string = "Server Busy"
      elseif bot.status == 11 then
        status_string = "Guest Limit"
      elseif bot.status == 12 then
        status_string = "Http Block"
      elseif bot.status == 13 then
        status_string = "Bad name length"
      elseif bot.status == 14 then
        status_string = "Invalid Account"
      elseif bot.status == 15 then
        status_string = "Error Connecting"
      elseif bot.status == 16 then
        status_string = "Logon Fail"
      elseif bot.status == 18 then
        status_string = "Captcha Requested"
      elseif bot.status == 17 then
        status_string = "Mod entered"
      elseif bot.status == 19 then
        status_string = "High Load"
      else
        status_string = "Unknown"
      end

      -- Get bot level
      local level_string = string.format("Level: %s", bot.level)

      -- Get bot current world
      local world_string = string.format("Current World: %s", bot:getWorld().name)
		-- Bot current gem count
	   local gem_string = string.format("Current Gems: %s", bot.gem_count)
      table.insert(bot_info, string.format("Bot Name: %s, Bot Status: %s, %s, %s, %s", bot.name, status_string, level_string, world_string,gem_string))
    end

    -- Prepare response content
    local response_content = table.concat(bot_info, "\n")

    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "GET, POST"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"

    -- Set the response content and type
    response:setContent(response_content, "text/plain")
  else
    response:setContent("Invalid Key.", "text/plain")
  end
end)

server:get("/bot/disconnect_all", function(request, response)
  local is_valid_key = request:getParam("secret") == "ilovebots"

  if is_valid_key then
    -- Iterate through all bots and disconnect them
    for _, bot in pairs(getBots()) do
      bot.auto_reconnect = false
      bot:disconnect()
    end

    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "GET, POST"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"

    response:setContent("All bots disconnected.", "text/plain")
  else
    response:setContent("Invalid Key.", "text/plain")
  end
end)


server:get("/bot/connect_all", function(request, response)
  local is_valid_key = request:getParam("secret") == "ilovebots"

  if is_valid_key then
    for _, bot in pairs(getBots()) do
      bot:connect()
      bot.auto_reconnect = true
      sleep(1000)
    end

    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "GET, POST"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"

    response:setContent("All bots disconnected.", "text/plain")
  else
    response:setContent("Invalid Key.", "text/plain")
  end
end)


server:post("/bot/add_bot", function(request, response)
  local is_valid_key = request:getParam("secret") == "ilovebots"
  if is_valid_key then
    local name = request:getParam("name")
    local password = request:getParam("password")  -- New parameter for the text
    if name then

      addBot(name, password)
      response.headers["Access-Control-Allow-Origin"] = "*"
      response.headers["Access-Control-Allow-Methods"] = "GET, POST"
      response.headers["Access-Control-Allow-Headers"] = "Content-Type"
  
      response:setContent("Bot " .. name .. " added", "text/plain")
    else
      response:setContent("Couldn't add bot.", "text/plain")
    end
  else
    response:setContent("Invalid Key.", "text/plain")
  end
end)

server:post("/bot/remove_bot", function(request, response)
  local is_valid_key = request:getParam("secret") == "ilovebots"
  if is_valid_key then
    local name = request:getParam("name")
    if name then
      removeBot(name)
      response.headers["Access-Control-Allow-Origin"] = "*"
      response.headers["Access-Control-Allow-Methods"] = "GET, POST"
      response.headers["Access-Control-Allow-Headers"] = "Content-Type"
  
      response:setContent("Bot " .. name .. " removed", "text/plain")
    else
      response:setContent("Couldn't remove bot.", "text/plain")
    end
  else
    response:setContent("Invalid Key.", "text/plain")
  end
end)





server:listen("0.0.0.0", 80)
