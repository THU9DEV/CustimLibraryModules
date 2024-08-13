export type Embed = {
    title: string?,
    description: string?,
    url: string?,
    color: number?, -- Hex color code for embed color (decimal)
    footer: { text: string, icon_url: string? }?,
    image: { url: string? }?,
    thumbnail: { url: string? }?,
    fields: { name: string, value: string, inline: boolean }[]?,
}

export type Data = {
    url: string,
    content: string | table | number | boolean,
    embeds: Embed[]?,
    Err_Resp: string?,
    Succ_Resp: string?
}

local Webhook = {}
Webhook.__index = Webhook

function Webhook.new()
    local self = setmetatable({}, Webhook)
    return self
end


    if not data.url or type(data.url) ~= "string" then
        error("Invalid or missing URL")
    end

 
    local payload = {}

  
    if type(data.content) == "string" then
        payload.content = data.content
    elseif type(data.content) == "table" or type(data.content) == "number" or type(data.content) == "boolean" then
        payload.content = game:GetService("HttpService"):JSONEncode(data.content)
    else
        error("Unsupported data type for webhook content")
    end

  
    if data.embeds and type(data.embeds) == "table" then
        payload.embeds = {}
        for _, embed in ipairs(data.embeds) do
            local embedPayload = {}
            if embed.title then embedPayload.title = embed.title end
            if embed.description then embedPayload.description = embed.description end
            if embed.url then embedPayload.url = embed.url end
            if embed.color then embedPayload.color = embed.color end
            if embed.footer then embedPayload.footer = embed.footer end
            if embed.image then embedPayload.image = embed.image end
            if embed.thumbnail then embedPayload.thumbnail = embed.thumbnail end
            if embed.fields then embedPayload.fields = embed.fields end
            table.insert(payload.embeds, embedPayload)
        end
    end


    local payloadJson = game:GetService("HttpService"):JSONEncode(payload)


    local success, result = pcall(function()
        return game:GetService("HttpService"):PostAsync(data.url, payloadJson, Enum.HttpContentType.ApplicationJson)
    end)

 
    if not success then
        local errorMsg = data.Err_Resp or "Failed to send data to webhook: "
        warn(errorMsg .. tostring(result))
    else
        local successMsg = data.Succ_Resp or "Data sent to webhook successfully!"
        print(successMsg)
    end
end


return Webhook
