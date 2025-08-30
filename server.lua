RegisterNetEvent("md_carmenu:syncToggleDoor")
AddEventHandler("md_carmenu:syncToggleDoor", function(netId, door)
    if not netId then return end
    TriggerClientEvent("md_carmenu:toggleDoor", -1, netId, door)
end)

RegisterNetEvent("md_carmenu:syncToggleWindow")
AddEventHandler("md_carmenu:syncToggleWindow", function(netId, window)
    if not netId then return end
    TriggerClientEvent("md_carmenu:toggleWindow", -1, netId, window)
end)


RegisterNetEvent("md_carmenu:requestSeat")
AddEventHandler("md_carmenu:requestSeat", function(netId, seat)
    local src = source
    TriggerClientEvent("md_carmenu:setSeat", src, netId, seat)
end)


RegisterNetEvent("md_carmenu:toggleEngine")
AddEventHandler("md_carmenu:toggleEngine", function(netId)
    if not netId then return end
    local src = source
    TriggerClientEvent("md_carmenu:engine", src, netId)
end)
