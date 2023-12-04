
WebhookUrl = " "
function GonWebhook(desc)
  wh = Webhook.new(WebhookUrl)
  wh.username = "CHAOS BOT"
  wh.avatar_url = "https://hotpotmedia.s3.us-east-2.amazonaws.com/8-tMAtY6FgnVINsJa.png?nc=1"
  wh.embed1.use = true
  wh.embed1.description = desc
  wh.embed1.color = 0xFF0000 
  wh:send()
end

function stringOfConsoleMessage(varlist,netid)
    if varlist:get(0):getString() == "OnConsoleMessage" then
        local message = varlist:get(1):getString()
        message = message:gsub("CP:%d+_PL:%d+_OID:_CT:%[SB%]_ ", "")
        message = message:gsub("%*", ""):gsub("%^", ""):gsub("`[1-9*]", ""):gsub("`", ""):gsub("%$", "")
        GonWebhook(message)
    end
end

addEvent(Event.variantlist,stringOfConsoleMessage)
listenEvents(9999999)
