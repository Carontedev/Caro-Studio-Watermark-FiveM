fx_version 'cerulean'
game 'gta5'

author 'caronte_logo'
description 'Caro-Studio-Watermark - NUI watermark logo'
version '1.0.0'

lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/app.js',
    'html/style.css',
    'html/assets/logo.png',
    'html/assets/logo2.png',
}

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'