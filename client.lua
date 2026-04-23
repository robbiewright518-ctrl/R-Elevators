local activeElevatorId = nil
local activeFloorIndex = nil

local function lib()
    return exports['R-Lib']
end

local function fadeTeleport(toVec4)
    local ped = PlayerPedId()

    DoScreenFadeOut(Config.FadeOut)
    while not IsScreenFadedOut() do Wait(0) end

    RequestCollisionAtCoord(toVec4.x, toVec4.y, toVec4.z)
    SetEntityCoordsNoOffset(ped, toVec4.x, toVec4.y, toVec4.z, false, false, false)
    SetEntityHeading(ped, toVec4.w or 0.0)

    local timeout = GetGameTimer() + 2000
    while not HasCollisionLoadedAroundEntity(ped) and GetGameTimer() < timeout do
        Wait(0)
    end

    DoScreenFadeIn(Config.FadeIn)
end



local function openElevatorMenu(elevator, currentFloorIndex)
    local options = {}
    for i, floor in ipairs(elevator.floors) do
        local isHere = i == currentFloorIndex
        options[#options + 1] = {
            id = tostring(i),
            title = floor.label .. (isHere and ' (You are here)' or ''),
            description = floor.description or '',
            disabled = isHere,
        }
    end

    activeElevatorId = elevator.id
    activeFloorIndex = currentFloorIndex

    lib():registerContext({
        id = 'r_elevators:' .. elevator.id,
        title = elevator.label,
        options = options,
    })

    lib():showContext('r_elevators:' .. elevator.id, { closeDistance = 4.0 })
end


local function isNearElevator()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    
    if IsPedInAnyVehicle(ped, false) then return nil end
    
    for _, elevator in ipairs(Config.Elevators) do
        for floorIndex, floor in ipairs(elevator.floors) do
            local distance = #(pedCoords - floor.interact)
            local maxDistance = floor.distance or 2.0
            
            if distance <= maxDistance then
                return elevator, floorIndex, floor, distance
            end
        end
    end
    
    return nil
end

CreateThread(function()
    while true do
        local elevator, floorIndex, floor, distance = isNearElevator()
        
        if elevator and floor then
            lib():showTextUI({
                text = elevator.label,
                key = 'E',
                position = 'right',
                coords = floor.interact,
            })

            if IsControlJustPressed(0, 51) then
                openElevatorMenu(elevator, floorIndex)
            end
        else
            lib():hideTextUI()
        end
        
        Wait(0)
    end
end)

AddEventHandler('r_lib:context:selected', function(menuId, optionId)
    if type(menuId) ~= 'string' then
        return
    end

    local prefix = 'r_elevators:'
    if menuId:sub(1, #prefix) ~= prefix then
        return
    end

    local elevId = menuId:sub(#prefix + 1)
    if not elevId then
        return
    end

    local idx = tonumber(optionId)
    if not idx then
        return
    end

    for _, elevator in ipairs(Config.Elevators) do
        if elevator.id == elevId then
            local floor = elevator.floors[idx]
            if floor and floor.teleport then
                fadeTeleport(floor.teleport)
                lib():hideContext()
            end
            break
        end
    end
end)
