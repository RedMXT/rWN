ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}



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
end)
------------------------------------

local MainMenu = RageUI.CreateMenu("Journaliste", "Garage Journaliste");
MainMenu.EnableMouse = false;

function RageUI.PoolMenus:MainMenu()
	MainMenu:IsVisible(function(Items)
			Items:AddSeparator("↓  ~o~~h~Garage Auto ~s~ ↓")
            for k,v in pairs(Config.garage.listeVeh) do
                Items:AddButton(k, "Sortir un "..k, { IsDisabled = false }, function(onSelected)
                    if (onSelected) then
                        spawnCar(v, k)
                    end
                end)
            end
            
	end, function(Panels)
	end)
end

local zone = Config.garage.marker

local drawDistance = 10.0
local interactionDistance = 1.0

CreateThread(function()
    while (true) do
        local interval = 250
        local playerPos = GetEntityCoords(PlayerPedId())
        local dst = #(zone-playerPos)
    
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'journalist' then
            if (dst <= drawDistance) then
                interval = 0
                DrawMarker(22, zone, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                if (dst <= interactionDistance) then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le garage")
                    if (IsControlJustPressed(0, 51)) then
                        RageUI.Visible(MainMenu, not RageUI.Visible(MainMenu))
                    end
                end
            end
        end
        Wait(interval)
    end
end)