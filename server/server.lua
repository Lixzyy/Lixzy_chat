ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getPlayerRPName(playerId)
    local playerName = GetPlayerName(playerId)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            playerName = xPlayer.getName()
        end
    end
    return playerName
end

RegisterNetEvent('mon_chat:sendMessage')
AddEventHandler('mon_chat:sendMessage', function(message)
    local source = source
    local playerName = getPlayerRPName(source)
    message = string.gsub(message, "<", "&lt;")
    message = string.gsub(message, ">", "&gt;")
    local formattedMessage = "<b>" .. playerName .. ":</b> " .. message
    TriggerClientEvent('mon_chat:addMessage', source, formattedMessage)
    print(string.format("[Chat Privé] %s: %s", playerName, message))
end)

RegisterNetEvent('mon_chat:execute3DCommand')
AddEventHandler('mon_chat:execute3DCommand', function(type, message)
    local source = source
    if message and message ~= "" then
        TriggerClientEvent('mon_chat:show3DText', -1, source, message, type)
    end
end)

RegisterCommand('twt', function(source, args, rawCommand)
    local playerName = getPlayerRPName(source)
    local message = table.concat(args, " ")
    if message == "" then
        TriggerClientEvent('mon_chat:addMessage', source, "<b style='color:#f44336;'>[SYSTEM]</b> Usage: /twt [message]")
        return
    end
    local formattedMessage = "<b style='color: #03a9f4;'><i class='fa-brands fa-twitter'></i> [Tweet] @" .. playerName .. ":</b> " .. message
    TriggerClientEvent('mon_chat:addMessage', -1, formattedMessage)
    print(string.format("[Tweet] %s: %s", playerName, message))
end, false)