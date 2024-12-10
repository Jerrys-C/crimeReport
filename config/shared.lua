return {
    tenCodes = {
        ["carjack"] = {
            tencode = '10-59',
            title = locale('title.carjack'),
            description = locale('tencodes.carjack'),
            jobs = { jobs = { 'police', 'sheriff' }, types = { 'leo' } },
            blip = {
                radius = 0,
                sprite = 595,
                colour = 60,
                scale = 1.5,
                length = 60 * 2,
                flashes = false,
                offset = false,
            },
            sound = {
                name = "Lose_1st",
                ref = "GTAO_FM_Events_Soundset",
            }
        },
        ["vehicletheft"] = {
            tencode = '487',
            title = locale('title.vehicletheft'),
            description = locale('tencodes.vehicletheft'),
            jobs = { jobs = { 'police', 'sheriff' }, types = { 'leo' } },
            blip = {
                radius = 0,
                sprite = 595,
                colour = 60,
                scale = 1.5,
                length = 60 * 2,
                offset = false,
                flashes = false
            },
            sound = {
                name = "Lose_1st",
                ref = "GTAO_FM_Events_Soundset",
            }
        },
        ["driveby"] = {
            tencode = '10-13',
            title = locale('title.driveby'),
            description = locale('tencodes.driveby'),
            name = locale('tencodes.driveby'),
            jobs = { jobs = { 'police', 'sheriff' }, types = { 'leo' } },
            blip = {
                sprite = 119,
                radius = 120.0,
                colour = 1,
                scale = 0,
                length = 60 * 2,
                flashes = false,
                offset = {
                    min = 20,
                    max = 100
                },
            },
            sound = {
                name = "Lose_1st",
                ref = "GTAO_FM_Events_Soundset",
            }
        },
        ["shooting"] = {
            tencode = '10-13',
            title = locale('title.shooting'),
            description = locale('tencodes.shooting'),
            jobs = { jobs = { 'police', 'sheriff' }, types = { 'leo' } },
            blip = {
                radius = 120.0,
                sprite = 110,
                colour = 1,
                scale = 1.0,
                length = 60 * 2,
                flashes = false,
                offset = {
                    min = 20,
                    max = 100
                },
            },
            sound = {
                ref = "GTAO_FM_Events_Soundset",
                name = "Lose_1st",
            }
        },
        ["fight"] = {
            tencode = '10-10',
            title = locale('title.fight'),
            description = locale('tencodes.fight'),
            jobs = { jobs = { 'police', 'sheriff' }, types = { 'leo' } },
            blip = {
                radius = 80.0,
                colour = 69,
                scale = 1.0,
                length = 60 * 2,
                sprite = 685,
                offset = {
                    min = 20,
                    max = 50
                },
                flashes = false
            },
            sound = {
                name = "Lose_1st",
                ref = "GTAO_FM_Events_Soundset",
            }
        },
        ["weaponthreat"] = {
            tencode = '240',
            title = locale('title.weaponthreat'),
            description = locale('tencodes.weaponthreat'),
            jobs = { jobs = { 'police', 'sheriff' }, types = { 'leo' } },
            blip = {
                radius = 80.0,
                colour = 69,
                scale = 1.0,
                length = 60 * 2,
                sprite = 567,
                offset = {
                    min = 20,
                    max = 50
                },
                flashes = false
            },
            sound = {
                name = "Lose_1st",
                ref = "GTAO_FM_Events_Soundset",
            }
        },
        ["murder"] = {
            tencode = '187',
            title = locale('title.murder'),
            description = locale('tencodes.murder'),
            jobs = { jobs = { 'police', 'sheriff' }, types = { 'leo' } },
            blip = {
                radius = 80.0,
                colour = 69,
                scale = 1.0,
                length = 60 * 2,
                sprite = 303,
                offset = {
                    min = 20,
                    max = 50
                },
                flashes = false
            }
        },
        ["RecklessDriving"] = {
            tencode = '502',
            title = locale('tencodes.carboosting'),
            description = locale('tencodes.carboosting'),
            jobs = { jobs = { 'police', 'sheriff' }, types = { 'leo' } },
            blip = {
                radius = 0,
                sprite = 380,
                colour = 60,
                scale = 1.5,
                length = 30 * 2,
                offset = false,
                flashes = false
            },
            sound = {
                name = "Lose_1st",
                ref = "GTAO_FM_Events_Soundset",
            }
        },
        ["explosion"] = {
            tencode = '10-80',
            title = locale('title.explosion'),
            description = locale('tencodes.explosion'),
            jobs = { jobs = { 'police', 'sheriff', 'ambulance' }, types = { 'leo' } },
            blip = {
                radius = 0,
                sprite = 436,
                colour = 1,
                scale = 1.5,
                length = 60 * 2,
                offset = false,
                flashes = false
            },
            sound = {
                name = "Lose_1st",
                ref = "GTAO_FM_Events_Soundset",
            }
        },
    },

    origen_tenCodes = { -- ORIGEN_POLICE
        ['10-59'] = 'RADARS',         -- Escort or vehicle theft monitoring
        ['487'] = '215',              -- Vehicle theft
        ['10-13'] = 'FORCE',          -- Officer in danger or critical incident (driveby, shooting)
        ['10-10'] = 'FORCE',          -- Fight in progress
        ['240'] = 'DRUGS',            -- Weapon threat (potentially linked to drug-related crimes)
        ['187'] = 'FORCE',            -- Homicide (requires tactical response)
        ['502'] = 'RADARS',           -- Reckless driving (road monitoring)
        ['10-80'] = 'GENERAL',        -- Pursuit in progress (covers multiple incident types)
    }
    
}
