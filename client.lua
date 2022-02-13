local QBCore = exports['qb-core']:GetCoreObject()
local inUIPage = false

local function DrawText3Ds (coords, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(coords.x, coords.y, coords.z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

local function buyBusiness_Open()
    if not inUIPage then
        print('inUIPage', inUIPage)
        QBCore.Functions.TriggerCallback('buyBusness:server:getCompany', function(result)
            print('result', result, #result)
            if result then
                local PlayerData = QBCore.Functions.GetPlayerData()
                SendNUIMessage({
                    action = "open",
                    bool = true,
                    --name = shop.company,
                    --label = shop.label,
                    items = result,
                    citizenid = PlayerData.citizenid
                })
                print('result', json.encode(result))
                SetNuiFocus(true, true)
                inUIPage = true
            else
                QBCore.Functions.Notify("Что то пошло не так", "error", 5000)
            end
        end)
    end
end

RegisterNetEvent('buyBusness:client:openUI', function(result)
   buyBusiness_Open()
    
end)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    inUIPage = false
end)


RegisterNUICallback('update', function(data, cb)
   print ('RegisterNUICallback', data.type, data.id)
   local PlayerData = QBCore.Functions.GetPlayerData()
   if data.type == 'buy' then
    QBCore.Functions.TriggerCallback('buyBusness:server:BuyCompany', function(result)
        --print('result', result, #result)
        if result then
            for i, v in pairs(result) do
                --print(i,v, v.name, v.owner)
            end
            cb('ok')
            SendNUIMessage({
                action = "refresh",
                bool = true,
                --name = shop.company,
                --label = shop.label,
                items = result,
                citizenid = PlayerData.citizenid
            })
        else
            QBCore.Functions.Notify("Что то пошло не так", "error", 5000)
    
        end
    end, data.id)
   else
    QBCore.Functions.TriggerCallback('buyBusness:server:sellCompany', function(result)
        if result then
            for i, v in pairs(result) do
                --print(i,v, v.name, v.owner)
            end
            cb('ok')
            SendNUIMessage({
                action = "refresh",
                bool = true,
                --name = shop.company,
                --label = shop.label,
                items = result,
                citizenid = PlayerData.citizenid
            })

        else
            QBCore.Functions.Notify("Что то пошло не так", "error", 5000)
    
        end
    end, data.id)
   end 
  
end)



Citizen.CreateThread(function()
    businessBlip = AddBlipForCoord(Config.Place)

    SetBlipSprite (businessBlip, 375)
    SetBlipDisplay(businessBlip, 4)
    SetBlipScale  (businessBlip, 0.65)
    SetBlipAsShortRange(businessBlip, true)
    SetBlipColour(businessBlip, 0)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Биржа бизнесов")
    EndTextCommandSetBlipName(businessBlip)
end)


Citizen.CreateThread(function()
    while true do

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        inRange = false

        local dist = #(pos - Config.Place)
        

        if dist < 20 then
            inRange = true
            DrawMarker(2, Config.Place.x, Config.Place.y, Config.Place.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.2, 155, 152, 234, 155, false, false, false, true, false, false, false)
            if #(pos - vector3(Config.Place.x, Config.Place.y, Config.Place.z)) < 1.5 then
                DrawText3Ds(Config.Place, '~g~E~w~ - Биржа бизнесов')
                if IsControlJustPressed(0, 38) then
                    buyBusiness_Open()
                end
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end

        Citizen.Wait(2)
    end
end)