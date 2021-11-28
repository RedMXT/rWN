
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'journalist', 'Journalist', 'society_wn', 'society_wn', 'society_wn', {type = 'public'})

RegisterNetEvent('cam:propscam')
AddEventHandler('cam:propscam', function()
    local src = source
    TriggerClientEvent("cam:campropsgive", src)
end)



RegisterServerEvent('rWN:open')
AddEventHandler('rWN:open', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Weazel News', '~b~Annonce', 'Le studio Weazel news est ouvert !', 'CHAR_GANGAPP', 8)
	end
end)



RegisterServerEvent('rWN:close')
AddEventHandler('rWN:close', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Weazel News', '~b~Annonce', 'Le studio Weazel news est fermé.', 'CHAR_GANGAPP', 8)
	end
end)



RegisterServerEvent('rWN:recru')
AddEventHandler('rWN:recru', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Weazel News', '~b~Annonce', 'Le studio Weazel recrute ! Venez vous présenter.', 'CHAR_GANGAPP', 8)
	end
end)





ESX.RegisterServerCallback('rWN:getStockItems', function(source, cb)
    local all_items = {}
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_wn', function(inventory)
        for k,v in pairs(inventory.items) do
            if v.count > 0 then
                table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
				print(v.label.."/"..v.name.."/"..v.count)
				
            end
        end

    end)
    cb(all_items)
end)

RegisterServerEvent('rWN:putStockItems')
AddEventHandler('rWN:putStockItems', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item_in_inventory = xPlayer.getInventoryItem(itemName).count

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_wn', function(inventory)
        if item_in_inventory >= count and count > 0 then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'en avez pas assez sur vous")
        end
    end)
end)

RegisterServerEvent('rWN:takeStockItems')
AddEventHandler('rWN:takeStockItems', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_wn', function(inventory)
            xPlayer.addInventoryItem(itemName, count)
            inventory.removeItem(itemName, count)
    end)
end)


ESX.RegisterServerCallback('rWN:playerinventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items   = xPlayer.inventory
    local all_items = {}

    for k,v in pairs(items) do
        if v.count > 0 then
            table.insert(all_items, {label = v.label, item = v.name,nb = v.count})
        end
    end


    cb(all_items)


end)