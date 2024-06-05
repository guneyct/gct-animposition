RegisterNetEvent("gct-animposition:server:syncPlayer", function(coords, heading, alpha)
    local source = source
    TriggerClientEvent("gct-animposition:client:syncPlayer", -1, source, coords, heading, alpha)
end)