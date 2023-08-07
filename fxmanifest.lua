fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'

author 'Elzetia'
description 'An equivalent to RDO\'s Merchant System, you fill out a camp that gives you access to a delivery in one of the cities'

client_script {
    "client/native.lua",
    "client/html_functions.lua",
	"client/client.lua",
    "client/delivery.lua",
    "client/menu.lua",
    "client/goods.lua",
    "client/supply.lua",
    "client/menuf.lua",
}
server_script {
    "server/native.lua",
	"server/server.lua",
    'server/database.lua'
}
shared_script {
    'config.lua',
    'locale.lua',
    'languages/*.lua',
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/images/*png",
}

dependencies {
    'vorp_menu',
}