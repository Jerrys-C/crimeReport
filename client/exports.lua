local config = require 'config.client'
local tenCodes = require('config.shared').tenCodes
local useScreenShot = config.useScreenShot

local automatics = {
    -95776620,
    970310034,
    1159398588,
    584646201,
}

local delay = 0
if config.globalAlertDelay > 0 then
    delay = config.globalAlertDelay
end


local function sendAlert(data)
    if not data then return end
    delay = data.delay or delay
    Wait(delay)
    if lib.callback.await('crimeReport:checkLocationCooldown', data.location, data.tencodeid) then
        return
    end
    data.blip = tenCodes[data.tencodeid].blip

    if useScreenShot then
        local apiToken = GetConvar("screenshot_basic_api_token", "")
        if not apiToken or apiToken == "" then
            Citizen.Trace("screenshot_basic_api_token is not set, please set it in your server.cfg or set useScreenShot to false in the config.lua")
            return
        end
        Wait(500)
        exports['screenshot-basic']:requestScreenshotUpload('https://api.fivemanage.com/api/image',
        'file',
        {
            headers = {
                Authorization = apiToken
            },
            encoding = 'jpg'
        },
        function(resData)
            local resp = json.decode(resData)
            if resp then
                data.image = resp.url
                lib.callback('crimeReport:triggerDispatch', false, function () end, data)
            end
        end)
    else
        lib.callback('crimeReport:triggerDispatch', false, function () end, data)
    end
end

local function VehicleTheft(vehicle)
    local vehdata = GetVehicleData(vehicle)
    local data = {
        tencodeid = "vehicletheft",
        tencode = tenCodes["vehicletheft"].tencode,
        location = GetLocation(GetEntityCoords(vehicle)),
        model = vehdata.name,
        class = vehdata.class,
        plate = vehdata.plate,
        doors = vehdata.doors,
        type = 0,
        color = vehdata.color,
        heading = vehdata.heading,
        coords = GetEntityCoords(vehicle),
        title = tenCodes["vehicletheft"].title,
        jobs = tenCodes["vehicletheft"].jobs
    }
    sendAlert(data)
end
exports('VehicleTheft', VehicleTheft)

local function CarJacking(vehicle)
    local vehdata = GetVehicleData(vehicle)
    local data = {
        tencodeid = "carjack",
        tencode = tenCodes["carjack"].tencode,
        location = GetLocation(GetEntityCoords(cache.ped)),
        model = vehdata.name,
        class = vehdata.class,
        plate = vehdata.plate,
        doors = vehdata.doors,
        type = 0,
        color = vehdata.color,
        heading = vehdata.heading,
        coords = GetEntityCoords(cache.vehicle),
        title = tenCodes["carjack"].title,
        jobs = tenCodes["carjack"].jobs
    }
    sendAlert(data)
end
exports('CarJacking', CarJacking)


local function DriveBy(vehicle)
    vehicle = vehicle or cache.vehicle
    local vehdata = GetVehicleData(vehicle)
    local data =  {
        tencodeid = "driveby",
        tencode = tenCodes["driveby"].tencode,
        location = GetLocation(GetEntityCoords(vehicle)),
        model = vehdata.name,
        class = vehdata.class,
        plate = vehdata.plate,
        speed = vehdata.speed,
        weapon = math.random() <= 0.5 and (exports.ox_inventory:getCurrentWeapon() and exports.ox_inventory:getCurrentWeapon().label) or locale("general.unknown"),
        weaponclass = GetWeaponClass(cache.weapon) or nil,
        automatic = math.random() <= 0.5 and (automatics[GetWeapontypeGroup(cache.weapon)] or automatics[cache.weapon]) or false,
        doors = vehdata.doors,
        type = 0,
        color = vehdata.color,
        heading = vehdata.heading,
        coords = GetEntityCoords(vehicle),
        title = tenCodes["driveby"].title,
        jobs = tenCodes["driveby"].jobs
    }
    sendAlert(data)
end
exports('DriveBy', DriveBy)

local function Shooting()
    local data = {
        tencodeid = "shooting",
        tencode = tenCodes["shooting"].tencode,
        location = GetLocation(GetEntityCoords(cache.ped)),
        weapon = math.random() <= 0.5 and exports.ox_inventory:getCurrentWeapon()?.label or locale("general.unknown"),
        weaponclass = GetWeaponClass(cache.weapon) or nil,
        type = 0,
        automatic = math.random() <= 0.5 and automatics[GetWeapontypeGroup(cache.weapon)] or false,
        coords = GetEntityCoords(cache.ped),
        title = tenCodes["shooting"].title,
        jobs = tenCodes["shooting"].jobs
    }
    sendAlert(data)
end
exports('Shooting', Shooting)

local function Fight()
    local data = {
        tencodeid = "fight",
        tencode = tenCodes["fight"].tencode,
        location = GetLocation(GetEntityCoords(cache.ped)),
        type = 0,
        coords = GetEntityCoords(cache.ped),
        title = tenCodes["fight"].title,
        jobs = tenCodes["fight"].jobs
    }
    sendAlert(data)
end
exports('Fight', Fight)

local function WeaponThreat()
    local data = {
        tencodeid = "weaponthreat",
        tencode = tenCodes["weaponthreat"].tencode,
        location = GetLocation(GetEntityCoords(cache.ped)),
        weapon = math.random() <= 0.5 and exports.ox_inventory:getCurrentWeapon()?.label or locale("general.unknown"),
        weaponclass = GetWeaponClass(cache.weapon) or nil,
        type = 0,
        coords = GetEntityCoords(cache.ped),
        title = tenCodes["weaponthreat"].title,
        jobs = tenCodes["weaponthreat"].jobs
    }
    sendAlert(data)
end
exports('WeaponThreat', WeaponThreat)

local function Murder()
    local data = {
        tencodeid = "murder",
        tencode = tenCodes["murder"].tencode,
        location = GetLocation(GetEntityCoords(cache.ped)),
        weapon = math.random() <= 0.5 and exports.ox_inventory:getCurrentWeapon()?.label or locale("general.unknown"),
        weaponclass = GetWeaponClass(cache.weapon) or nil,
        type = 0,
        coords = GetEntityCoords(cache.ped),
        title = tenCodes["murder"].title,
        jobs = tenCodes["murder"].jobs
    }
    sendAlert(data)
end
exports('Murder', Murder)


local function Explosion(coords)
    TriggerServerEvent("y_dispatch:server:AddCall",{
        tencodeid = "explosion",
        tencode = tenCodes["explosion"].tencode,
        location = GetLocation(coords),
        type = 0,
        coords = coords,
        title = tenCodes["explosion"].title,
        jobs = tenCodes["explosion"].jobs
    })
end
exports('Explosion', Explosion)

local function RecklessDriving(vehicle)
    local vehdata = GetVehicleData(vehicle)
    if not vehdata then return end
    local data = {
        tencode = tenCodes["RecklessDriving"].tencode,
        tencodeid = "RecklessDriving",
        location = GetLocation(GetEntityCoords(cache.ped)),
        heading = vehdata.heading,
        model = vehdata.name,
        class = vehdata.class,
        plate = vehdata.plate,
        speed = vehdata.speed,
        doors = vehdata.doors,
        type = 0,
        color = vehdata.color,
        coords = GetEntityCoords(cache.ped),
        title = tenCodes["RecklessDriving"].title,
        jobs = tenCodes["RecklessDriving"].jobs
    }
    sendAlert(data)
end
exports('RecklessDriving', RecklessDriving)
