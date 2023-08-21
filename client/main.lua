---@diagnostic disable: missing-parameter, param-type-mismatch
-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Trusted Development || DEBUG-Print
-- ════════════════════════════════════════════════════════════════════════════════════ --

if Trusted.Debug then
    local filename = function()
        local str = debug.getinfo(2, "S").source:sub(2)
        return str:match("^.*/(.*).lua$") or str
    end
    print("^6[SHARED - DEBUG] ^0: "..filename()..".lua started");
end

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

Flares = {
    Entities = {}
}

function Flares:CanShoot(vehicle)
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and not IsEntityDead(vehicle) then
        local model = GetEntityModel(vehicle)
        if Config.Flare_models[model] then
            return true
        end
    end
    return false
end

function Flares:Shoot(entity, ped, modelConfig)
    for i = 1, modelConfig.mode do 
        local position = GetEntityCoords(entity)
        local offset1 = GetOffsetFromEntityInWorldCoords(entity, 1.0, -4.0, 0)
        local offset2 = GetOffsetFromEntityInWorldCoords(entity, -1.0, -4.0, 0)
        ShootSingleBulletBetweenCoordsIgnoreEntityNew(position, offset1, 0, true, self.Hash, ped, true, true, Config.Speed, entity, false, false, false, true, true, false)
        Wait(50)
        ShootSingleBulletBetweenCoordsIgnoreEntityNew(position, offset2, 0, true, self.Hash, ped, true, true, Config.Speed, entity, false, false, false, true, true, false)
        Wait(100)
        Flares.Entities[entity] -= 1
    end
end

RegisterKeyMapping('+shootFlares', 'Shoot flares from a dedicated plane.', 'keyboard', 'E')

RegisterCommand('+shootFlares', function()
    local ped = PlayerPedId()

    if not IsPedInAnyVehicle(ped, false) then
        return 
    end

    local entity = GetVehiclePedIsIn(ped, false)

    if not Flares:CanShoot(entity) then 
        return 
    end

    if Flares.Timeout then 
        RequestScriptAudioBank('DLC_SM_Countermeasures_Sounds')
        PlaySoundFromEntity(-1, 'flares_empty', entity, 'DLC_SM_Countermeasures_Sounds', true)
        return 
    end

    local model = GetEntityModel(entity)
    local modelConfig = Config.Flare_models[model]

    Flares.Timeout = true 

    SetTimeout(300 * modelConfig.mode, function()
        Flares.Timeout = false
    end)

    if Flares.IsShooting then 
        return
    end

    Flares.IsShooting = true

    if not Flares.Entities[entity] then 
        Flares.Entities[entity] = modelConfig.limit

        Flares.Hash = GetHashKey("weapon_flaregun")
        
        RequestScriptAudioBank('DLC_SM_Countermeasures_Sounds')
        RequestModel(Flares.Hash)
        RequestWeaponAsset(Flares.Hash, 31, 26)
    elseif Flares.Entities[entity] <= 0 then 
        PlaySoundFromEntity(-1, 'flares_empty', entity, 'DLC_SM_Countermeasures_Sounds', true)
        return 
    end
    
    PlaySoundFromEntity(-1, 'flares_released', entity, 'DLC_SM_Countermeasures_Sounds', true)

    while Flares.IsShooting do 
        if Flares.Entities[entity] <= 0 then 
            Flares.IsShooting = false 
            PlaySoundFromEntity(-1, 'flares_empty', entity, 'DLC_SM_Countermeasures_Sounds', true)
        end

        Flares:Shoot(entity, ped, modelConfig)

        Wait(Config.FlareInterval)   
    end

end, false)

RegisterCommand('-shootFlares', function()
    Flares.IsShooting = false
end, false)

function Flares:Refill(entity)
    local model = GetEntityModel(entity)
    self.Entities[entity] = Config.Flare_models[model].limit
end

exports('RefillFlares', function(entity)
    Flares:Refill(entity)
end)