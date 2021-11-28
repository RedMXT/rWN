ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

all_items = {}

---------------- FONCTIONS ------------------


local MainMenu = RageUI.CreateMenu("Journaliste", "Stock Journaliste");
MainMenu.EnableMouse = false;

local PutStock = RageUI.CreateSubMenu(MainMenu, "Retirer Stock", "Retirer du stock")
local GetStock = RageUI.CreateSubMenu(MainMenu, "Voir Stock", "Voir le stock")

function RageUI.PoolMenus:MainMe()
	MainMenu:IsVisible(function(Items)
			Items:AddSeparator("↓  ~o~~h~Gestion coffre ~s~ ↓")
            
            Items:AddButton("Déposer", "Déposer du stock", { IsDisabled = false }, function(onSelected)
                getInventory()
            end, PutStock)
            
            Items:AddButton("Retirer", "Retirer du stock", { IsDisabled = false }, function(onSelected)
                getStock()
            end, GetStock)


			Items:AddSeparator("↓  ~g~~h~Stock ~s~ ↓")
           
            
	end, function()
	end)
    
    
    GetStock:IsVisible(function(Items)
		Items:AddSeparator("↓  Stock Entreprise ↓")
        for k,v in pairs(all_items) do
            Items:AddButton(v.label, nil, { RightLabel = "~r~x"..v.nb}, function(onSelected)
                if (onSelected) then
                local count = KeyboardInput("Combien voulez vous retirer",nil,4)
                count = tonumber(count)
                    if count <= v.nb then
                        TriggerServerEvent("rWN:takeStockItems",v.item, count)
                    else
                        Notification("~r~Vous n'en avez pas assez sur vous")
                    end
                    getStock()
                end
            end)
        end
    end, function()
    end)
    
    
    PutStock:IsVisible(function(Items)
		-- Items
		Items:AddSeparator("↓  Stock Entreprises ↓")
        for k,v in pairs(all_items) do
            Items:AddButton(v.label, nil, {RightLabel = "~r~x"..v.nb}, function(onSelected)
                if (onSelected) then
                    local count = KeyboardInput("Combien voulez vous déposer",nil,4)
                    count = tonumber(count)
                    TriggerServerEvent("rWN:putStockItems",v.item, count)
                    getInventory()
                end
            end)
        end

    end, function() 
    end)
end



local zone = Config.coffre.position

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
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le coffre")
                    if (IsControlJustPressed(0, 51)) then
                        RageUI.Visible(MainMenu, not RageUI.Visible(MainMenu))
                    end
                end
            end
        end
        Wait(interval)
    end
end)

function getInventory()
    ESX.TriggerServerCallback('rWN:playerinventory', function(inventory)       
        all_items = inventory
    end)
end

function getStock()
    ESX.TriggerServerCallback('rWN:getStockItems', function(inventory)                     
        all_items = inventory
    end)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end