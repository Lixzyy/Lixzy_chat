-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'lixzy'
description 'Lixzy chat'
version '1.0.0'

-- Fichiers à charger
files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

-- Page NUI
ui_page 'html/index.html'

-- Scripts
client_script 'client/client.lua'
server_script 'server/server.lua'