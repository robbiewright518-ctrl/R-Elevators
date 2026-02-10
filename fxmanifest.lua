fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'R-Elevators'

shared_scripts {
    '@ox_lib/init.lua',
    '@sleepless_interact/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

dependencies {
    'ox_lib',
    'sleepless_interact'
}
