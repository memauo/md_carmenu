local closed = 1
local menuOpen = false
local InVeh = 0
local veh = 0
RegisterKeyMapping('carmenu', 'Open Car Menu', 'keyboard', 'M')
RegisterCommand("carmenu", function()


    closed = 1 - closed
    if closed==0 and InVeh == 1 then
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        menuOpen = true
        SendNuiMessage(json.encode({
            action = "menu",
            closed = 0,
        }))
    else
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        menuOpen = false
        SendNuiMessage(json.encode({
            action = "menu",
            closed = 1,
        }))
    end
end)

RegisterKeyMapping('toggleengine', 'Toggle vehicle engine', 'keyboard', 'N')
RegisterCommand("toggleengine", function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        TriggerServerEvent("md_carmenu:toggleEngine", VehToNet(vehicle))
    end
end)

CreateThread(function()
    print("MD Carmenu has loaded successfully")
    while true do
            local playerPed = PlayerPedId()
        veh = GetVehiclePedIsIn(playerPed, false)
        if veh ~= 0 then
            InVeh = 1
        else
            InVeh = 0
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            menuOpen = false
            closed = 1
            SendNuiMessage(json.encode({
                action = "menu",
                closed = 1,
            }))
        end
        Wait(0)
        if menuOpen then
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
        end
    end
end)

local windowStates = { [0] = 0, [1] = 0, [2] = 0, [3] = 0 }

RegisterNetEvent("md_carmenu:toggleDoor")
AddEventHandler("md_carmenu:toggleDoor", function(netId, door)
    local vehicle = NetToVeh(netId)
    if DoesEntityExist(vehicle) then
        local doorIndex = tonumber(door)
        if not doorIndex then return end
        local doorAngle = GetVehicleDoorAngleRatio(vehicle, doorIndex)
        if doorAngle > 0.1 then
            SetVehicleDoorShut(vehicle, doorIndex, false)
        else
            SetVehicleDoorOpen(vehicle, doorIndex, false, false)
        end
    end
end)

RegisterNetEvent("md_carmenu:toggleWindow")
AddEventHandler("md_carmenu:toggleWindow", function(netId, window)
    local vehicle = NetToVeh(netId)
    if DoesEntityExist(vehicle) then
        local index = tonumber(window)
        if not index then return end

        if windowStates[index] == 0 then
            RollDownWindow(vehicle, index)
            windowStates[index] = 1
        else
            RollUpWindow(vehicle, index)
            windowStates[index] = 0
        end
    end
end)

RegisterNUICallback("toggleDoor", function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 then
        local coords = GetEntityCoords(playerPed)
        local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        if veh ~= 0 then vehicle = veh end
    end
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        local door = tonumber(data.door)
        if door then
            local netId = VehToNet(vehicle)
            TriggerServerEvent("md_carmenu:syncToggleDoor", netId, door)
        end
    end
    cb("ok")
end)

RegisterNUICallback("toggleWindow", function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 then
        local coords = GetEntityCoords(playerPed)
        local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        if veh ~= 0 then vehicle = veh end
    end
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        local window = tonumber(data.window)
        if window then
            local netId = VehToNet(vehicle)
            TriggerServerEvent("md_carmenu:syncToggleWindow", netId, window)
        end
    end
    cb("ok")
end)


RegisterNUICallback("switchSeat", function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        local seat = tonumber(data.seat)
        if seat ~= nil then
            TriggerServerEvent("md_carmenu:requestSeat", VehToNet(vehicle), seat)
        end
    end
    cb("ok")
end)

RegisterNetEvent("md_carmenu:setSeat")
AddEventHandler("md_carmenu:setSeat", function(netId, seat)
    local vehicle = NetToVeh(netId)
    if DoesEntityExist(vehicle) and IsVehicleSeatFree(vehicle, seat) then
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, seat)
    end
end)

RegisterNUICallback("toggleEngine", function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        TriggerServerEvent("md_carmenu:toggleEngine", VehToNet(vehicle))
    end
    cb("ok")
end)

RegisterNetEvent("md_carmenu:engine")
AddEventHandler("md_carmenu:engine", function(netId)
    local vehicle = NetToVeh(netId)
    if DoesEntityExist(vehicle) then
        SetVehicleEngineOn(vehicle, false, false, true)
    end
end)

