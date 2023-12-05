function stringOfConsoleMessage(varlist,netid)
    if varlist:get(0):getString() == "OnConsoleMessage" then
        local message = varlist:get(1):getString()
        if message:find("nuked from orbit") then
            message = message:gsub("`[w4%d]", ""):gsub("`", "")
            GonWebhook("<:2480:1181339612044611734> "..message)
        end
    end
end

WebhookUrl = ""
function GonWebhook(desc)
  wh = Webhook.new(WebhookUrl)
  wh.username = "CHAOS BOT"
  wh.avatar_url = "https://hotpotmedia.s3.us-east-2.amazonaws.com/8-tMAtY6FgnVINsJa.png?nc=1"
  wh.embed1.use = true
  wh.embed1.description = desc
  wh.embed1.color = 0xFF0000 
  wh:send()
end

function stringOfSB(varlist, netid)
    if varlist:get(0):getString() == "OnConsoleMessage" then
        local message = varlist:get(1):getString()

        local pattern = "from %((.-)%) in %[(.-)%]"

        local match1, match2 = message:match(pattern)

        -- Check if the message matches the pattern
        if match1 and match2 then
            -- Remove the specific prefix and additional characters inside ( ) and [ ]
            message = message:gsub("CP:%d+_PL:%d+_OID:_CT:%[SB%]_ ", "")
            message = message:gsub("%*", ""):gsub("%^", ""):gsub("`[1-9*]", ""):gsub("`", ""):gsub("%$", "")
            GonWebhook("<:7234:1181514179467808890> " ..message)
        end
    end
end
addEvent(Event.variantlist,stringOfConsoleMessage)
addEvent(Event.variantlist,stringOfSB)
listenEvents(99999999999)
