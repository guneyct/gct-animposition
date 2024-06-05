ESX = exports["es_extended"]:getSharedObject()

RegisterCommand("animpos", function (source, args, raw)
    local _src = source
    TriggerClientEvent("gct-animpos:client:animPos", _src)
end)