ESX = exports["es_extended"]:getSharedObject()

CreateThread(function()
    AddTextEntry("GCT_UP", "Yukarı Taşı ~INPUT_CELLPHONE_UP~~n~Aşağı Taşı ~INPUT_CELLPHONE_DOWN~~n~Sola Taşı ~INPUT_CELLPHONE_LEFT~~n~Sağa Taşı ~INPUT_CELLPHONE_RIGHT~~n~~n~Sağa Döndür ~INPUT_PICKUP~~n~Sola Döndür ~INPUT_FRONTEND_LB~~n~~n~İleri Git ~INPUT_SCRIPT_PAD_UP~~n~Geri Git ~INPUT_FRONTEND_LB~")
    AddTextEntry("GCT_CANCEL", "Çıkmak için ~INPUT_CELLPHONE_CAMERA_EXPRESSION~ Tuşuna Basın")
end)

local animPos = false
RegisterNetEvent("gct-animpos:client:animPos", function(playerServerId)
    if animPos == true then
        ESX.ShowNotification("Şuanda kullanamazsın!", "error")
        return 
    end
    if not exports["rpemotes"]:IsPlayerInAnim() then
        ESX.ShowNotification("Animasyonda değilsin!", "error")
        return 
    end
    animPosition(PlayerPedId())
end)

function showKeys(number)
    if number == 1 then
        BeginTextCommandDisplayHelp("GCT_UP")
        EndTextCommandDisplayHelp(0, true, false, -1)
    else
        BeginTextCommandDisplayHelp("GCT_CANCEL")
        EndTextCommandDisplayHelp(0, true, false, -1)
        Wait(3500)
        hideKeys()
    end
end

function hideKeys()
    ClearAllHelpMessages()
end

function disableControls()
    DisableAllControlActions()

    EnableControlAction(0, 245, true)
    EnableControlAction(0, 270, true)
    EnableControlAction(0, 271, true)
    EnableControlAction(0, 272, true)
    EnableControlAction(0, 273, true)
    EnableControlAction(0, 1, true)
    EnableControlAction(0, 2, true)
    EnableControlAction(0, 4, true)
    EnableControlAction(0, 5, true)
end

function animPosition(playerPed)
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    FreezeEntityPosition(playerPed, true)

    local posChanged = false
    animPos = not animPos
    showKeys(1)

    while true do
        disableControls()

        local tempCoord = GetEntityCoords(playerPed)
        local x = tempCoord.x
        local y = tempCoord.y
        local z = tempCoord.z
        local heading = GetEntityHeading(playerPed)
        local dist = GetDistanceBetweenCoords(playerCoords, tempCoord, true)
        SetEntityAlpha(playerPed, 50, false)

        if dist <= 8.0 then
            if IsDisabledControlJustPressed(0, 38) then -- rot
                heading = heading - 5
                SetEntityHeading(playerPed, heading)
            end

            if IsDisabledControlJustPressed(0, 205) then
                heading = heading + 5
                SetEntityHeading(playerPed, heading)
            end

            if IsDisabledControlJustPressed(0, 172) then
                z = z + 0.1
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true)
            end

            if IsDisabledControlJustPressed(0, 173) then
                z = z - 0.1
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true)
            end

            if IsDisabledControlJustPressed(0, 174) then -- sola
                x = x + 0.1
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true)
            end

            if IsDisabledControlJustPressed(0, 175) then -- sağa
                local head = GetEntityHeading(playerPed)
                x = x - 0.1
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true)
            end

            if IsDisabledControlJustPressed(0, 232) then -- ileri
                y = y + 0.1
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true)
            end

            if IsDisabledControlJustPressed(0, 233) then -- geri
                y = y - 0.1
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true)
            end

            if IsDisabledControlJustPressed(0, 191) then
                posChanged = true
                ResetEntityAlpha(playerPed)
                break
            end
        else
            posChanged = false
            break
        end

        Wait(1)
    end

    hideKeys()
    showKeys(2)

    while posChanged do
        if IsControlJustReleased(0, 186) then
            posChanged = false
            break
        end

        Wait(1)
    end

    if not posChanged then
        ResetEntityAlpha(playerPed)
        SetEntityCoords(playerPed, playerCoords)
        SetEntityHeading(playerPed, playerHeading)
        FreezeEntityPosition(playerPed, false)
        animPos = false

        hideKeys()
    end
end