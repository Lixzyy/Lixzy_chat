local chatVisible = false

local availableCommands = {
    {name = '/me', help = 'Décrire une action RP au-dessus de votre tête.'},
    {name = '/ooc', help = 'Parler en Hors-RP au-dessus de votre tête.'},
    {name = '/twt', help = 'Envoyer un message sur Twitter.'},
    {name = '/clear', help = 'Effacer votre propre fenêtre de chat.'},
    {name = '/showid', help = 'Montrer votre carte d_identité à un joueur proche.'},
    {name = '/showlicense', help = 'Montrer votre permis de conduire.'},
    {name = '/pay', help = 'Donner de l_argent à un joueur proche. /pay [id] [montant]'},
    {name = '/ad', help = 'Passer une annonce publique.'},
    {name = '/report', help = 'Signaler un problème à un administrateur. /report [message]'},
    {name = '/dv', help = 'Supprimer le véhicule que vous regardez.'},
    {name = '/engine', help = 'Allumer ou éteindre le moteur.'},
    {name = '/hood', help = 'Ouvrir/fermer le capot.'},
    {name = '/trunk', help = 'Ouvrir/fermer le coffre.'},
    {name = '/door', help = 'Ouvrir/fermer une porte. /door [1-6]'},
    {name = '/car', help = '[Admin] Faire apparaître un véhicule. /car [modèle]'},
    {name = '/noclip', help = '[Admin] Activer/désactiver le mode NoClip.'},
    {name = '/setjob', help = '[Admin] Changer le métier. /setjob [id] [métier] [grade]'},
    {name = '/kick', help = '[Admin] Exclure un joueur. /kick [id] [raison]'},
    {name = '/ban', help = '[Admin] Bannir un joueur. /ban [id] [raison]'},
    {name = '/slap', help = '[Admin] Giffer un joueur. /slap [id]'},
    {name = '/clearall', help = '[Admin] Effacer le chat pour tous les joueurs.'},
    {name = '/announce', help = '[Admin] Envoyer un message à tout le serveur.'},

}

function SetChatVisible(visible)
    chatVisible = visible
    SetNuiFocus(visible, visible)
    SendNUIMessage({ type = "ui", display = visible })
    SendNUIMessage({ type = "setInputVisible", payload = visible })
    if visible then
        SendNUIMessage({ type = "commandList", commands = availableCommands })
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 245) and not chatVisible then
            SetChatVisible(true)
        end
    end
end)

RegisterNUICallback('chatMessage', function(data, cb)
    local message = data.message
    SetChatVisible(false)
    if message and message ~= "" then
        if string.sub(message, 1, 1) == '/' then
            ExecuteCommand(string.sub(message, 2))
        else
            TriggerServerEvent('mon_chat:sendMessage', message)
        end
    end
    cb('ok')
end)

RegisterNUICallback('chatClosed', function(data, cb)
    SetChatVisible(false)
    cb('ok')
end)

RegisterNetEvent('mon_chat:addMessage')
AddEventHandler('mon_chat:addMessage', function(formattedMessage)
    SendNUIMessage({ type = "message", html = formattedMessage })
end)

local active3DTexts = {}
RegisterNetEvent('mon_chat:show3DText')
AddEventHandler('mon_chat:show3DText', function(targetSource, text, type)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSource))
    if targetPed then
        active3DTexts[targetSource] = {
            ped = targetPed,
            text = text,
            type = type,
            endTime = GetGameTimer() + 10000
        }
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local currentTime = GetGameTimer()
        for source, data in pairs(active3DTexts) do
            if currentTime > data.endTime then
                active3DTexts[source] = nil
            else
                if data.ped and DoesEntityExist(data.ped) then
                    local targetCoords = GetEntityCoords(data.ped)
                    if #(playerCoords - targetCoords) < 25.0 then
                        local textToDisplay, color
                        if data.type == 'me' then
                            textToDisplay = '* ' .. data.text
                            color = {255, 255, 255, 255}
                        elseif data.type == 'ooc' then
                            textToDisplay = '(( ' .. data.text .. ' ))'
                            color = {224, 133, 255, 255}
                        end
                        if textToDisplay then
                            DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.0, textToDisplay, color)
                        end
                    end
                else
                    active3DTexts[source] = nil
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text, color)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(color[1], color[2], color[3], color[4])
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterCommand('me', function(source, args)
    TriggerServerEvent('mon_chat:execute3DCommand', 'me', table.concat(args, " "))
end, false)
RegisterCommand('ooc', function(source, args)
    TriggerServerEvent('mon_chat:execute3DCommand', 'ooc', table.concat(args, " "))
end, false)
RegisterCommand('clear', function()
    SendNUIMessage({ type = "clearChat" })
end, false)

RegisterNetEvent('mon_chat:addNotification')
AddEventHandler('mon_chat:addNotification', function(message, type)
    SendNUIMessage({
        type = "notification",
        message = message,
        nType = type or 'info'
    })
end)

RegisterCommand('testnotif', function()
    TriggerEvent('mon_chat:addNotification', 'Ceci est un test de succès.', 'success')
    Citizen.Wait(500)
    TriggerEvent('mon_chat:addNotification', 'Ceci est un test d_erreur.', 'error')
    Citizen.Wait(500)
    TriggerEvent('mon_chat:addNotification', 'Ceci est un test d_info.', 'info')
end, false)