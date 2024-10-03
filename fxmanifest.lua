fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Mr.Bolux as Bob Togolo'
description 'Job Ammunation'
version '1.0.0'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/main.lua',
    'client/harvesting.lua',
    'client/processing.lua',
    -- 'client/production.lua',
}

server_scripts {
    'server/main.lua',
}

shared_scripts {
	'config.lua',
	'config/harvesting.lua',
	'config/processing.lua',
	-- 'config/production.lua',
}

dependencys {
    'togolo_lib',
}