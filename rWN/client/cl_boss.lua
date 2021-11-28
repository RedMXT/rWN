ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societytaximoney = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
    print(ESX.PlayerData.job)
end)




------------------------------------

local zoneb = Config.boss.position



local drawDistance = 10.0
local interactionDistance = 1.0

CreateThread(function()
    while (true) do
        local interval = 250
        local playerPos = GetEntityCoords(PlayerPedId())
        local dst = #(zoneb-playerPos)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'journalist' and ESX.PlayerData.job.grade_name == 'boss' then
            if (dst <= drawDistance) then
                interval = 0
                DrawMarker(22, zoneb, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                if (dst <= interactionDistance) then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir l'ordinateur de gestion d'entreprises")
                    if (IsControlJustPressed(0, 51)) then
                        TriggerEvent('esx_society:openBossMenu', 'wn', function(data, menu)
                            menu.close()
                        end, {wash = false})
                    end
                end
            end
        end
        Wait(interval)
    end
end)