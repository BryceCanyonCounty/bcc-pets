
fx_version "adamant"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

version '3.0.0'
games {"rdr3"}

client_scripts {
    'client/*.lua'
}

shared_scripts {
    'config.lua',
	'locale.lua',
	'locales/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

dependency 'vorp_core'
