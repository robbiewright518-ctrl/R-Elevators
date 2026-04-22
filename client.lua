local currentMenu = nil
local menuItems = {}
local selectedIndex = 1
local isMenuOpen = false

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

local function drawMenu()
    if not isMenuOpen or not currentMenu then return end

    DrawRect(0.5, 0.5, 0.3, 0.05 + (#menuItems * 0.04), 0, 0, 0, 200)
    DrawRect(0.5, 0.25, 0.3, 0.05, 0, 0, 0, 255)
    
    DrawText2D(currentMenu.title, 0.5, 0.25, 0.5, 0.5, {255, 255, 255}, true, true)
    
    for i, item in ipairs(menuItems) do
        local y = 0.3 + (i - 1) * 0.04
        local color = (i == selectedIndex) and {255, 255, 0} or {255, 255, 255}
        
        if item.disabled then
            color = {128, 128, 128}
        end
        
        DrawText2D(item.title, 0.5, y, 0.4, 0.4, color, true, true)
    end
end

local function DrawText2D(text, x, y, scale, font, color, center, outline)
    SetTextFont(font or 4)
    SetTextScale(scale, scale)
    SetTextColour(color[1], color[2], color[3], 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    
    if center then
        SetTextCentre(true)
    end
    
    if outline then
        SetTextOutline()
    end
    
    DrawText(x, y)
end

local function openElevatorMenu(elevator, currentFloorIndex)
    menuItems = {}
    currentMenu = {
        title = elevator.label,
        elevator = elevator,
        currentFloorIndex = currentFloorIndex
    }

    for i, floor in ipairs(elevator.floors) do
        local isHere = i == currentFloorIndex

        menuItems[#menuItems + 1] = {
            title = floor.label .. (isHere and " (You are here)" or ""),
            floor = floor,
            floorIndex = i,
            disabled = isHere
        }
    end

    selectedIndex = 1
    isMenuOpen = true
    
    while isMenuOpen do
        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 257, true)
        
        drawMenu()
        
        if IsControlJustPressed(0, 172) then
            repeat
                selectedIndex = selectedIndex - 1
                if selectedIndex < 1 then selectedIndex = #menuItems end
            until not menuItems[selectedIndex].disabled
        elseif IsControlJustPressed(0, 173) then
            repeat
                selectedIndex = selectedIndex + 1
                if selectedIndex > #menuItems then selectedIndex = 1 end
            until not menuItems[selectedIndex].disabled
        elseif IsControlJustPressed(0, 191) then
            local selectedItem = menuItems[selectedIndex]
            if selectedItem and not selectedItem.disabled then
                fadeTeleport(selectedItem.floor.teleport)
                isMenuOpen = false
            end
        elseif IsControlJustPressed(0, 194) then
            isMenuOpen = false
        end
        
        Wait(0)
    end
    
    currentMenu = nil
    menuItems = {}
end

local function draw3DText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        local dist = #(GetEntityCoords(PlayerPedId()) - coords)
        local scale = 0.5 * (1.0 / dist)
        
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
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
        local elevatorData = isNearElevator()
        
        if elevatorData then
            local elevator, floorIndex, floor, distance = elevatorData
            draw3DText(floor.interact, string.format("[E] %s", elevator.label))
            
            if IsControlJustPressed(0, 51) then 
                openElevatorMenu(elevator, floorIndex)
            end
        end
        
        Wait(0)
    end
end)
