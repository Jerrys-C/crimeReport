local classes = { locale('classes.compact'), locale('classes.sedan'), locale('classes.suv'), locale('classes.coupe'), locale('classes.muscle'), locale('classes.sports_classic'), locale('classes.sports'), locale('classes.super'), locale('classes.motorcycle'), locale('classes.offroad'), locale('classes.industrial'), locale('classes.utility'), locale('classes.van'), locale('classes.service'), locale('classes.military'), locale('classes.truck') }
local config = require 'config.client'

local function getCardinalDirection(entity)
    -- heading is between 0 - 360 (excluding 360)
    local heading = GetEntityHeading(entity) % 360

    if heading < 45 or heading >= 315 then
        return locale("heading.north")
    end

    if heading >= 45 and heading < 135 then
        return locale("heading.west")
    end

    if heading >= 135 and heading < 225 then
        return locale("heading.south")
    end

    -- heading >= 225 and heading < 315
    return locale("heading.east")
end

--- returns the vehicle's data ( model, class, name, plate, NetId, speed, color, n° of doors)
---@param vehicle number
---@return table
function GetVehicleData(vehicle)
    local vehicleData = {}
    vehicleData.class = classes[GetVehicleClass(vehicle)]
    vehicleData.plate = GetVehicleNumberPlateText(vehicle)
    vehicleData.id = NetworkGetNetworkIdFromEntity(vehicle)
    vehicleData.speed = GetEntitySpeed(vehicle)
    vehicleData.heading = getCardinalDirection(vehicle)
    if not config.useMPH then
        vehicleData.speed = vehicleData.speed * 3.6
    end
    vehicleData.speed = math.floor(vehicleData.speed) .. (config.useMPH and " MPH" or " KM/H")
    vehicleData.name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))

    local primary, secondary = GetVehicleColours(vehicle)
    local color1, color2 = locale('colors.' .. primary), locale('colors.' .. secondary)
    vehicleData.color = ((color1 and color2) and (color2 .. " & " .. color1)) or (color1 and color1) or (color2 and color2) or locale('general.unknown')

    local doorcount = 0
    local doors = { 'door_dside_f', 'door_pside_f', 'door_dside_r', 'door_pside_r' }
    for i = 1, #doors do
        if GetEntityBoneIndexByName(vehicle, doors[i]) ~= -1 then doorcount = doorcount + 1 end
    end
    vehicleData.doors = doorcount >= 2 and locale('vehDetails.' .. doorcount .. '_door')
    return vehicleData
end

local weaponThreatAntiSpam = false

local WeaponClasses = {
    [2685387236] = locale('WeaponClasses.melee'),
    [416676503] = locale('WeaponClasses.gun'),
    [-95776620] = locale('WeaponClasses.submachinegun'),
    [860033945] = locale('WeaponClasses.shotgun'),
    [970310034] = locale('WeaponClasses.assaultrifle'),
    [1159398588] = locale('WeaponClasses.lightmachinegun'),
    [3082541095] = locale('WeaponClasses.sniper'),
    [2725924767] = locale('WeaponClasses.heavyweapon'),
    [1548507267] = locale('WeaponClasses.throwables'),
    [4257178988] = locale('WeaponClasses.misc'),
}

--- Returns the Class of a weapon (e.g. Melee, Handguns, Shotguns, etc.)
---@param SelectedWeapon number
---@return string
function GetWeaponClass(SelectedWeapon)
    return WeaponClasses[GetWeapontypeGroup(SelectedWeapon)] or locale('general.unknown')
end

--- Returns the street at coords
---@param coords vector3
---@return string
function GetStreet(coords)
    return GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
end

--- Returns the zone at coords
---@param coords vector3
---@return string
function GetZone(coords)
    return GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
end

--- Returns the location (street + zone) at coords
---@param coords vector3
---@return string
function GetLocation(coords)
	return GetStreet(coords) .. ", " .. GetZone(coords)
end
--#endregion Getter Functions

local invaildWitnessesTypes = {0, 1, 2, 3, 28} -- Player and Animal

--- Checks if there is a valid report from the given witnesses.
-- Iterates through the list of witnesses and checks if any of them are valid.
-- A witness is considered valid if it is not the current player character and 
-- its type is not in the list of invalid witness types.
-- @param witnesses A table containing the list of witness entities.
-- @return boolean True if there is at least one valid witness, false otherwise.
local function checkValidReport(witnesses)
    local vaild = false
    local vaildWitness = nil
    for _, ped in ipairs(witnesses) do
        if ped ~= cache.ped then
            for _, t in ipairs(invaildWitnessesTypes) do
                if GetPedType(ped) == t then
                    goto checkNextPed
                end
            end
            vaild = true
            vaildWitness = ped
            break
        end
        ::checkNextPed::
    end
    return vaildWitness
end

local function checkAnimalFirstReport(witnesses)
    if GetPedType(witnesses[1]) == 28 then
        return true
    else
        return false
    end
end

local fightAntiSpam = false
local function fight()
    fightAntiSpam = true
    exports.crimeReport:Fight()
    SetTimeout(30 * 1000, function()
        fightAntiSpam = false
    end)
end

local shotsfiredAntiSpam = false
local byPassWeapons = config.events.shotsfired.byPassWeapons

local function shotfired()
    local ped = cache.ped
    for k, _ in pairs(byPassWeapons) do
        if cache.weapon == GetHashKey(k) then return end
    end
    if IsPedCurrentWeaponSilenced(ped) and math.random() <= 0.98 then return end
    -- 2% chance to trigger the event if the weapon is silenced, ( real life weapons are not 100% silent ;c )

    shotsfiredAntiSpam = true
    weaponThreatAntiSpam = true
    if cache.vehicle then
        exports.crimeReport:DriveBy()
    else
        exports.crimeReport:Shooting()
    end
    SetTimeout(30 * 1000, function()
        shotsfiredAntiSpam = false
        weaponThreatAntiSpam = false
    end)
end

local recklessAntiSpam = false
local recklessCheckAntiSpam = false
local recklessCount = 0
local resetTimer = nil
local byPassVehicleClasses = {
    [14] = true,
    [15] = true,
    [16] = true,
    [21] = true
}
local function resetRecklessCount()
    recklessCount = 0
    resetTimer = nil
end
local function recklessDriver()
    if recklessCheckAntiSpam then return end
    if cache.vehicle then
        recklessCheckAntiSpam = true
        SetTimeout(config.events.recklessDriver.reportInterval * 1000, function() recklessCheckAntiSpam = false end)
        if IsVehicleSirenOn(cache.vehicle) then return end
        if byPassVehicleClasses[GetVehicleClass(cache.vehicle)] then return end

        recklessCount = recklessCount + 1

        if resetTimer == nil then
            SetTimeout(config.events.recklessDriver.resetInterval * 1000, resetRecklessCount)
            resetTimer = true
        end

        if recklessCount >= config.events.recklessDriver.reportThreshold then
            recklessAntiSpam = true
            exports.crimeReport:RecklessDriving(cache.vehicle)
            SetTimeout(config.events.recklessDriver.alertCoolDown * 1000, function()
                recklessAntiSpam = false
            end)
        end
    end
end


local carJackAntiSpam = false
local getInVehicleTimeOut = 10000
local function carJacking()
    carJackAntiSpam = true
    getInVehicleTimeOut = 10000
    -- check player entered a vehicle in 10 seconds
    while getInVehicleTimeOut > 0 do
        Wait(1000)

        if cache.vehicle then
            exports.crimeReport:CarJacking(cache.vehicle)
            SetTimeout(30 * 1000, function()
                carJackAntiSpam = false
            end)
            break
        end
        getInVehicleTimeOut = getInVehicleTimeOut - 1000
    end

end

local function weaponThreat()
    weaponThreatAntiSpam = true
    exports.crimeReport:WeaponThreat()
    SetTimeout(30 * 1000, function()
        weaponThreatAntiSpam = false
    end)
end

local vehicleTheftAntiSpam = false
local function vehicleTheft()
    if cache.vehicle then
        vehicleTheftAntiSpam = true
        exports.crimeReport:VehicleTheft(cache.vehicle)
        SetTimeout(30 * 1000, function()
            vehicleTheftAntiSpam = false
        end)
    end
end

local murderAntiSpam = false
local function murder(ped)
    murderAntiSpam = true
    exports.crimeReport:Murder()
    SetTimeout(30 * 1000, function()
        murderAntiSpam = false
    end)

end

--- Checks if the player's job is in the job whitelisted
---@param jobs any
---@param playerjob any
---@return boolean
local function isPlayerJobBypassed(jobs, playerjob)
    if not config.events.enabledJobWhitelist then return false end
    if jobs.jobs or jobs.types then
        if not jobs.jobs then goto skipjobs end
        for _, v in pairs(jobs.jobs) do
            if playerjob.name == v then
                return true
            end
        end
        ::skipjobs::
        if not jobs.types then goto skiptypes end
        for _, v in pairs(jobs.types) do
            if playerjob.type == v then
                return true
            end
        end
        ::skiptypes::
    else
        for _, v in pairs(jobs) do
            if playerjob.name == v then
                return true
            end
        end
    end
    return false
end


local function getPlayerJob()
    return QBX.PlayerData.job
end


if config.events.fight.enabled then
    AddEventHandler('CEventShockingSeenMeleeAction', function(witnesses, ped)
        Wait(100)
        if fightAntiSpam then return end
        if isPlayerJobBypassed(config.events.fight.jobwhitelist, getPlayerJob()) then return end
        if not checkValidReport(witnesses) then return end
        fight()
    end)
end

if config.events.shotsfired.enabled then
    AddEventHandler('CEventShockingGunshotFired', function(witnesses, _, _)
        Wait(100)
        if shotsfiredAntiSpam then return end
        if isPlayerJobBypassed(config.events.shotsfired.jobwhitelist, getPlayerJob()) then return end
        if not checkValidReport(witnesses) then return end
        shotfired()
    end)
end

if config.events.recklessDriver.enabled then
    AddEventHandler("CEventShockingMadDriverExtreme",function(witnesses, ped, _)
        Wait(100)
        if recklessAntiSpam then return end
        if isPlayerJobBypassed(config.events.recklessDriver.jobwhitelist, getPlayerJob()) then return end
        if not checkValidReport(witnesses) then return end
        recklessDriver()
    end)
    
    AddEventHandler("CEventShockingPedRunOver", function(witnesses, ped, _)
        Wait(100)
        if recklessAntiSpam then return end
        if isPlayerJobBypassed(config.events.recklessDriver.jobwhitelist, getPlayerJob()) then return end
        if not checkValidReport(witnesses) then return end
        recklessDriver()
    end)
end

if config.events.carjacking.enabled then
    AddEventHandler("CEventPedJackingMyVehicle", function(witnesses, ped, _)
        Wait(100)
        if carJackAntiSpam then return end
        if isPlayerJobBypassed(config.events.carjacking.jobwhitelist, getPlayerJob()) then return end
        if not checkValidReport(witnesses) then return end
        carJacking()
    end)
end

if config.events.weaponThreat.enabled then
    AddEventHandler("CEventShockingWeaponThreat", function(witnesses, ped, _)
        Wait(5000) -- Wait 5 seconds to check if the ped was shot or not
        if weaponThreatAntiSpam then return end
        if isPlayerJobBypassed(config.events.weaponThreat.jobwhitelist, getPlayerJob()) then return end
        if not checkValidReport(witnesses) then return end
        weaponThreat()
    end)
end

if config.events.vehicleTheft.enabled then
    AddEventHandler("CEventShockingSeenCarStolen", function(witnesses, ped, _)
        Wait(100)
        if vehicleTheftAntiSpam or carJackAntiSpam then return end
        if isPlayerJobBypassed(config.events.vehicleTheft.jobwhitelist, getPlayerJob()) then return end
        if not checkValidReport(witnesses) then return end
        vehicleTheft()
    end)
end

-- if config.events.murder.enabled then
--     AddEventHandler("CEventShockingSeenPedKilled", function(witnesses, ped, _)
--         if murderAntiSpam then return end
--         if checkAnimalFirstReport(witnesses) then return end
--         if not checkValidReport(witnesses) then return end
--         murder()
--     end)
-- end

