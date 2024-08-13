-- Import the Webhook library
local Webhook = require(game.ServerScriptService:WaitForChild("Webhook"))


local webhook = Webhook.new()


local webhookData = {
    url = "https://discord.com/api/webhooks/YOUR_WEBHOOK_URL",
    content = "Hello, this is a test message!",
    embeds = {
        {
            title = "Test Embed",
            description = "This is an embed description.",
            url = "https://example.com",
            color = 0x00ff00, -- Green color in hexadecimal
            footer = {
                text = "Footer Text",
                icon_url = "https://example.com/icon.png"
            },
            image = {
                url = "https://example.com/image.png"
            },
            thumbnail = {
                url = "https://example.com/thumbnail.png"
            },
            fields = {
                { name = "Field 1", value = "Value 1", inline = true },
                { name = "Field 2", value = "Value 2", inline = false }
            }
        }
    },
    Err_Resp = "Failed to send webhook message: ",
    Succ_Resp = "Webhook message sent successfully!"
}


webhook:send(webhookData)
