Config = {}
Config.Locale = 'fr'
Config.Debug = false

Config.blips = {
    ["Les Vignerons d'Hazzard"] = {
        coords = vector3(-1889.05, 2046.52, 140.87),
        sprite = 85,
        scale = 0.8,
        color = 27
    }
}

Config.duty = {
    vineyard = {
        coords = vector4(-1883.62, 2056.68, 140.98, 136.76),
        pedModel = 's_m_y_busboy_01',
    }
}

Config.stash = {
    vineyard = {
        {
            coords = vector3(-1869.66, 2066.12, 140.98),
            length = 1,
            width = 1.5,
            heading = 90,
            minZ = 139.98,
            maxZ = 141.98,
        },
        {
            coords = vector3(-1928.86, 2059.55, 140.84),
            length = 1.5,
            width = 1.5,
            heading = 166.91,
            minZ = 139.84,
            maxZ = 141.84,
        },
    },
}

Config.bossMenu = {
    vineyard = {
        {
            coords = vector3(-1877.29, 2060.29, 145.57),
            length = 1,
            width = 2.3,
            heading = 70,
            minZ = 144.57,
            maxZ = 146.00,
        },
    },
}

Config.radialMenu = {
    ["vineyard"] = {
        {
            id = "entreprise",
            title = "Entreprise",
            icon = "shop",
            items = {
                {
                    id = 'openStore',
                    title = 'Ouvrire',
                    icon = 'door-open',
                    type = 'client',
                    event = 'togolo_lib:client:showAdvancedNotification',
                    params = {
                        global = true,
                        message = 'Votre vignerons est désormais ouverte !',
                        sender = 'Les Vignerons d\'Hazzard',
                        subject = 'Ouvert',
                        textureDict = 'CHAR_AMMUNATION',
                        iconType = 2,
                        color = 18,
                    },
                    shouldClose = true
                },
                {
                    id = 'closeStore',
                    title = 'Fermer',
                    icon = 'door-closed',
                    type = 'client',
                    event = 'togolo_lib:client:showAdvancedNotification',
                    params = {
                        global = true,
                        message = 'Votre vignerons est désormais fermer !',
                        sender = 'Les Vignerons d\'Hazzard',
                        subject = 'Fermer',
                        textureDict = 'CHAR_AMMUNATION',
                        iconType = 2,
                        color = 6,
                    },
                    shouldClose = true
                },
            },
        },
    }
}