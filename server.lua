local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add("openBS", "Открыть интерфейс продажи бизнесов", {}, false, function(source)
    local result = exports.oxmysql:fetchSync('SELECT * FROM companies ', {})
    --print('result', json.encode(result))
    TriggerClientEvent('buyBusness:client:openUI', source, result)
  
end, "admin") 

QBCore.Functions.CreateCallback("buyBusness:server:getCompany", function(source, cb)
    local result1 = exports.oxmysql:fetchSync('SELECT * FROM companies ', {})
    if result1 ~= nil then
        cb(result1)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback("buyBusness:server:sellCompany", function(source, cb, id)
    local result = exports.oxmysql:fetchSync('SELECT * FROM companies WHERE id = ?', {id})
    if result[1] ~= nil then
        local Player = QBCore.Functions.GetPlayer(source)
        local price = math.ceil(result[1].price/2)
        --print(result[1].price, price)
        if price and price> 0 then 
            Player.Functions.AddMoney('bank', price)
        else
            TriggerClientEvent('QBCore:Notify',source,'Что топошло не так', 'error')
        end
    end
    
    local src = source
        --end
    exports.oxmysql:execute('UPDATE companies SET owner = ? WHERE id = ?',
    {'', id})
    Citizen.Wait(500)
    local result2 = exports.oxmysql:fetchSync('SELECT * FROM companies ', {})
    if result2 ~= nil then
        cb(result2)
    else
        cb(false)
    end

    
    
end)

QBCore.Functions.CreateCallback("buyBusness:server:BuyCompany", function(source, cb, id)
    local result = exports.oxmysql:fetchSync('SELECT * FROM companies WHERE id = ?', {id})
    local Player = QBCore.Functions.GetPlayer(source)
    local pay = false
    if result[1] ~= nil then
        
        local price = result[1].price

        if Player.PlayerData.money.cash >= price then
            Player.Functions.RemoveMoney('cash', price)
            pay = true
        elseif Player.PlayerData.money.bank >= price then
            Player.Functions.RemoveMoney('bank', price)
            pay = true
        else
            TriggerClientEvent('QBCore:Notify',source,'У вас нет денег на покупку', 'error')
        end
    end
    
    local src = source
        --end
    
    if pay then 
        exports.oxmysql:execute('UPDATE companies SET owner = ? WHERE id = ?', {Player.PlayerData.citizenid, id}) 
    end
    Citizen.Wait(500)
    local result2 = exports.oxmysql:fetchSync('SELECT * FROM companies ', {})
    if result2 ~= nil then
        cb(result2)
    else
        cb(false)
    end

    
    
end)