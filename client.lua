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
            title = floor.label .. (isHere and " (You are here)" or ""),
            description = floor.description,
            icon = isHere and "location-dot" or "arrow-up-right-from-square",
            disabled = isHere,
            onSelect = function()
                fadeTeleport(floor.teleport)
            end
        }
    end

    local ctxId = ("elevator:%s"):format(elevator.id)

    lib.registerContext({
        id = ctxId,
        title = elevator.label,
        options = options
    })

    lib.showContext(ctxId)
end

CreateThread(function()
    for _, elevator in ipairs(Config.Elevators) do
        for floorIndex, floor in ipairs(elevator.floors) do
            exports.sleepless_interact:addCoords(floor.interact, {
                label = elevator.label,
                icon = "elevator",
                distance = floor.distance or 2.0,
                canInteract = function()
                    return not IsPedInAnyVehicle(PlayerPedId(), false)
                end,
                onSelect = function()
                    openElevatorMenu(elevator, floorIndex)
                end
            })
        end
    end
end)
