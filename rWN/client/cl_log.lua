RegisterNetEvent('rWN:logs')
AddEventHandler('rWN:logs', function(webhook, Color, Title, Description)
	TriggerServerEvent('rWN:log', webhook, Color, Title, Description)
end)