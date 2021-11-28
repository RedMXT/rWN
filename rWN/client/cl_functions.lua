
ESX = nil

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

function spawnCar(model, name)
    local model = GetHashKey(model)
    RequestModel(model)
    while (not (HasModelLoaded(model))) do
        Wait(100)
    end
    local car = CreateVehicle(model, Config.garage.spawnVeh.position, Config.garage.spawnVeh.heading, true)
    TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)
	SetVehicleNumberPlateText("WEAZLENZ")
	ESX.ShowNotification("~g~~g~Véhicule "..name.." sortie !")
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, 177) and phone == true then -- CLOSE PHONE
			DestroyMobilePhone()
			phone = false
			CellCamActivate(false, false)
		end
		
			
		if phone == true then
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(19)
			HideHudAndRadarThisFrame()
		end
	end
end)


function Photo()
	CreateMobilePhone(phoneId)
	CellCamActivate(true, true)
	phone = true
end

local inCam = false
local camId = nil
local camModel = "prop_v_cam_01"
local camanimDict = "missfinale_c2mcs_1"
local camanimName = "fin_c2_mcs_1_camman"
local useBmic = false
local bmic_net  = nil
local bmicModel = "prop_v_bmike_01"
local bmicanimDict = "missfra1"
local bmicanimName = "mcs2_crew_idle_m_boom"
function ToogleBmic()
	if not useBmic then
		useBmic = true
		
		RequestModel(GetHashKey(bmicModel))
		while not HasModelLoaded(GetHashKey(bmicModel)) do
			Citizen.Wait(1)
		end
	
		local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
		local bmicspawned = CreateObject(GetHashKey(bmicModel), plyCoords.x, plyCoords.y, plyCoords.z, true, true, false)
		local netid = ObjToNet(bmicspawned)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		AttachEntityToEntity(bmicspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), -0.08, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
		TaskPlayAnim(GetPlayerPed(PlayerId()), bmicanimDict, bmicanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)

		bmic_net = netid

		Citizen.CreateThread(function()
			RequestAnimDict(bmicanimDict)
			while not HasAnimDictLoaded(bmicanimDict) do
				Citizen.Wait(1)
			end

			while useBmic do
	
				if not IsEntityPlayingAnim(PlayerPedId(), bmicanimDict, bmicanimName, 3) then
					TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
					TaskPlayAnim(GetPlayerPed(PlayerId()), bmicanimDict, bmicanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
				end
				
				DisablePlayerFiring(PlayerId(), true)
				DisableControlAction(0,25,true) -- disable aim
				DisableControlAction(0, 44,  true) -- INPUT_COVER
				DisableControlAction(0,37,true) -- INPUT_SELECT_WEAPON
				SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
				
				if (IsPedInAnyVehicle(GetPlayerPed(-1), -1) and GetPedVehicleSeat(GetPlayerPed(-1)) == -1) or IsPedCuffed(GetPlayerPed(-1)) then
					ClearPedSecondaryTask(GetPlayerPed(-1))
					DetachEntity(NetToObj(bmic_net), 1, 1)
					DeleteEntity(NetToObj(bmic_net))
					bmic_net = nil
					useBmic = false
				end
				Wait(1)
			end
		end)

	else
		useBmic = false
		ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
		DetachEntity(NetToObj(bmic_net), 1, 1)
		DeleteEntity(NetToObj(bmic_net))
		bmic_net = nil
	end
end
function ToogleCam()
	if not inCam then
		inCam = true
		RequestModel(GetHashKey(camModel))
		while not HasModelLoaded(GetHashKey(camModel)) do
			Citizen.Wait(1)
		end
		
		local pPed = GetPlayerPed(-1)
		local plyCoords = GetOffsetFromEntityInWorldCoords(pPed, 0.0, 0.0, -5.0)
		local camspawned = CreateObject(GetHashKey(camModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
		local netid = ObjToNet(camspawned)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		AttachEntityToEntity(camspawned, pPed, GetPedBoneIndex(pPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		TaskPlayAnim(pPed, 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
		TaskPlayAnim(pPed, camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
		camId = netid

		Citizen.CreateThread(function()
			while not HasAnimDictLoaded(camanimDict) do
				RequestAnimDict(camanimDict)
				Citizen.Wait(100)
			end

			while inCam do
				local pPed = GetPlayerPed(-1)
				if not IsEntityPlayingAnim(pPed, camanimDict, camanimName, 3) then
					TaskPlayAnim(pPed, 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
					TaskPlayAnim(pPed, camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
				end
					
				DisablePlayerFiring(PlayerId(), true)
				DisableControlAction(0,25,true) -- disable aim
				DisableControlAction(0, 44,  true) -- INPUT_COVER
				DisableControlAction(0,37,true) -- INPUT_SELECT_WEAPON
				SetCurrentPedWeapon(pPed, GetHashKey("WEAPON_UNARMED"), true)
				Wait(1)
			end
		end)
	else
		inCam = false

		ClearPedTasks(GetPlayerPed(-1))
		ClearPedSecondaryTask(GetPlayerPed(-1))
		DetachEntity(NetToObj(camId), 1, 1)
		DeleteEntity(NetToObj(camId))
		camId = nil
	end
end




function cleanArea()
	local obj, dist = ESX.Game.GetClosestObject({'prop_ld_greenscreen_01', 'prop_tv_cam_02', 'p_tv_cam_02_s','v_club_roc_micstd','v_ilev_fos_mic', 'prop_kino_light_02'})
	if dist < 4.0 then
	  DeleteEntity(obj)
	else
	  ESX.ShowNotification("~r~Impossible ~s~Vous êtes trop loin")
	end
end

function setPropsFix(props)
	local playerPed = GetPlayerPed(-1)              
	local x, y, z   = table.unpack(GetEntityCoords(playerPed))
	local xF = GetEntityForwardX(playerPed) * 1.0
	local yF = GetEntityForwardY(playerPed) * 1.0
	if props == "prop_ld_greenscreen_01" then
	z = z - 2.8
	elseif props == "prop_kino_light_02" then
	z = z + 5
	elseif props == "prop_tv_cam_02" then
	z = z - 2.8
	elseif props == "v_ilev_fos_mic" then
	end



	ESX.Game.SpawnObject(props, {
		x = x + xF,
		y = y + yF,
		z = z
	  }, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	  end)
	

end

function OpenBillingMenu()
    ESX.UI.Menu.Open(
        'dialog', GetCurrentResourceName(), 'facture',
        {
            title = 'Donner une facture'
        },
        function(data, menu)

            local amount = tonumber(data.value)

            if amount == nil or amount <= 0 then
                ESX.ShowNotification('Montant invalide')
            else
                menu.close()

                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Pas de joueurs proche')
                else
                    local playerPed        = GetPlayerPed(-1)

                    Citizen.CreateThread(function()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
                        Citizen.Wait(5000)
                        ClearPedTasks(playerPed)
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_pharmacie', 'Pharmacie', amount)
                        ESX.ShowNotification("~r~Vous avez bien envoyer la facture")
                    end)
                end
            end
        end,
        function(data, menu)
            menu.close()
    end)
end


local useMic = false
local mic_net = nil
local micModel = "p_ing_microphonel_01"
local micanimDict = "missheistdocksprep1hold_cellphone"
local micanimName = "hold_cellphone"
function ToogleMic()
	if not useMic then
		useMic = true
		RequestModel(GetHashKey(micModel))
		while not HasModelLoaded(GetHashKey(micModel)) do
			Citizen.Wait(100)
		end
	
		while not HasAnimDictLoaded(micanimDict) do
			RequestAnimDict(micanimDict)
			Citizen.Wait(1)
		end

		local pPed = GetPlayerPed(-1)
		local plyCoords = GetOffsetFromEntityInWorldCoords(pPed, 0.0, 0.0, -5.0)
		local micspawned = CreateObject(GetHashKey(micModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
		local netid = ObjToNet(micspawned)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		AttachEntityToEntity(micspawned, pPed, GetPedBoneIndex(pPed, 60309), 0.055, 0.05, 0.0, 240.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		TaskPlayAnim(pPed, 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
		TaskPlayAnim(pPed, micanimDict, micanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
		mic_net = netid

		Citizen.CreateThread(function()
			while useMic do
				if (IsPedInAnyVehicle(pPed, -1) and GetPedVehicleSeat(pPed) == -1) or IsPedCuffed(pPed) then
					ClearPedSecondaryTask(pPed)
					DetachEntity(NetToObj(mic_net), 1, 1)
					DeleteEntity(NetToObj(mic_net))
					mic_net = nil
					useMic = false
				end
				Wait(1)
			end
		end)

	else
		useMic = false
		ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
		DetachEntity(NetToObj(mic_net), 1, 1)
		DeleteEntity(NetToObj(mic_net))
		mic_net = nil
	end
end