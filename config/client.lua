return {
    useScreenShot = false, -- Use a screenshot for the dispatch
    globalAlertDelay = 2000, -- Delay in seconds before trigger alert
    useMPH = true, -- Use MPH instead of KMH

    events = {
        enabledJobWhitelist = false, -- Enable job whitelist for events (global)
        fight = {
            enabled = true,
            alertCoolDown = 60, -- Time in seconds before alerting again (client side)
            reportThreshold = 2, -- How many reports before alerting, Raising the threshold avoids triggering alerts from single, potentially minor incidents, reducing false positives.
            reportInterval = 3, -- Time interval in seconds for counting reports (e.g., 15 seconds)
            resetInterval = 60, -- Time interval in seconds for resetting the report count (e.g., 60 seconds)
            jobwhitelist = {
                'police',
                'sheriff',
            },
        },
        shotsfired = {
            enabled = true,
            jobwhitelist = {
                'sheriff',
            },
            byPassWeapons = {
                'WEAPON_FIREEXTINGUISHER',
                'WEAPON_SNOWBALL',
            },
        },
        weaponThreat = {
            enabled = true,
            jobwhitelist = {
                'sheriff',
            },
        },
        recklessDriver = {
            enabled = true,
            alertCoolDown = 60, -- Time in seconds before alerting again (client side)
            reportThreshold = 2, -- How many reports before alerting, Raising the threshold avoids triggering alerts from single, potentially minor incidents, reducing false positives.
            reportInterval = 15, -- Time interval in seconds for counting reports (e.g., 15 seconds)
            resetInterval = 60, -- Time interval in seconds for resetting the report count (e.g., 60 seconds)
            jobwhitelist = {
                'police',
                'sheriff',
            },
        },
        carjacking = {
            enabled = true,
            jobwhitelist = {
                'police',
                'sheriff',
            },
        },
        vehicleTheft = {
            enabled = true,
            jobwhitelist = {
                'police',
                'sheriff',
            },
        },
    }
}