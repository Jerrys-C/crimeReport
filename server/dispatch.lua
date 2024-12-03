-- dispatch.lua

local config = require 'config.server'
local dispatchSystem = config.dispatchSystem
local lastAlertTime = {}
local alertCooldown = 30 -- 30 seconds cooldown at each location(Street and Zone)

local function checkLocationCooldown(location, alertType)
    local currentTime = os.time()
    local key = location .. "_" .. alertType
    if lastAlertTime[key] and (currentTime - lastAlertTime[key] < alertCooldown) then
        warn("Alert on cooldown in " .. location .. " for type " .. alertType)
        return true
    end
    return false
end

lib.callback.register('crimeReport:checkLocationCooldown', checkLocationCooldown)

local function triggerDispatch(source, data)
    local loc = data.location
    local alertType = data.tencodeid
    local vehDetails = ""

    if checkLocationCooldown(loc, alertType) then
        return
    end

    local key = loc .. "_" .. alertType
    lastAlertTime[key] = os.time()

    if dispatchSystem == "rcore_dispatch" then
        if data.model then
            vehDetails = vehDetails .. locale("vehDetails.model") .. data.doors .. data.class .. "-" .. data.model .. "\n"
            vehDetails = vehDetails .. locale("vehDetails.color") .. data.color .. "\n"
            vehDetails = vehDetails .. locale("vehDetails.plate") .. data.plate .. "\n"
            vehDetails = vehDetails .. locale("vehDetails.speed") .. data.speed .. "\n"
            vehDetails = vehDetails .. locale("heading.title") .. data.heading
        end
        local blip = data.blip
        blip.text = data.title
        blip.radius = nil
        blip.length = nil
        local callData = {
            code = data.tencode,
            default_priority = 'low',
            coords = data.coords,
            job = data.jobs.jobs,
            text = data.title .. " - " .. data.location .. "\n" .. vehDetails,
            type = 'alerts',
            blip_time = 5,
            blip = blip
        }
        if data.image then
            callData.image = data.image
        end
        TriggerEvent('rcore_dispatch:server:sendAlert', callData)
    end

    if dispatchSystem == "your_dispatch_system" then
        -- Your dispatch system code here
    end
    
end

lib.callback.register('crimeReport:triggerDispatch', triggerDispatch)