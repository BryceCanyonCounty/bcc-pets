
fx_version "adamant"

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

games {"rdr3"}

version '2.0.0'

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua'
}

shared_scripts {
    'config.lua',
	'locale.lua',
	'locales/es.lua',
	'locales/en.lua',
}

dependency 'vorp_core'
