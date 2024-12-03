fx_version 'cerulean'
game 'gta5'

author 'Jerry'
description 'NPC Crime Report System'
repository ''
version '1.0.0'

ox_lib 'locale'
shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua'
}

files {
    'config/client.lua',
    'config/shared.lua',
    'locales/*.json',
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

dependencies {
    'ox_lib',
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
