
local MainMenu = RageUI.CreateMenu("Journaliste", "Intéractions Journalistes");
MainMenu.EnableMouse = false;

local Annonce = RageUI.CreateSubMenu(MainMenu, "Annonce", "Passer des annnonces")
local Objet = RageUI.CreateSubMenu(MainMenu, "Objet", "Poser des objets...")

local Checked = false;
local ListIndex = 1;


local GridX, GridY = 0, 0
function RageUI.PoolMenus:Example()
	MainMenu:IsVisible(function(Items)
		Items:CheckBox("Prise De Service", "Prendre son service !", Checked, { Style = 2 }, function(onSelected, IsChecked)
			if (onSelected) then
				Checked = IsChecked
			end
		end)
		if Checked then
			Items:AddSeparator("↓  ~o~~h~Menu Weazle News ~s~ ↓")
			Items:AddButton("📝 Facture", "Mettre une facture", { IsDisabled = false }, function(onSelected)
				if (onSelected) then
					OpenBillingMenu()
				end
			end)

			Items:AddButton("📢 Annonce", "Passer des annnonces", { IsDisabled = false }, function(onSelected)
			end, Annonce)

			Items:AddButton("🎤 Objet", "Poser des objets", { IsDisabled = false }, function(onSelected)
			end, Objet)
			Items:AddSeparator("↓  ~b~~h~Tournage ~s~ ↓ ")

			Items:AddButton("📷 Photo", "Prendre une photo", { IsDisabled = false }, function(onSelected)
				if (onSelected) then
					Photo()
				end
			end)
		else
		end

	end, function(Panels)
		-- Après le menu (Visuel)
	end)

	Annonce:IsVisible(function(Items)
		-- Items
		Items:AddSeparator("↓  ~s~Annonce ~g~~h~Ouverture~s~/~h~~r~Fermeture ~s~ ↓")


		Items:AddButton("Ouvert !", "Annoncer l'ouverture", { IsDisabled = false }, function(onSelected)
			if (onSelected) then
                TriggerServerEvent('rWN:open')
				TriggerEvent('rWN:logs', Config.webhook.url["ouvert"], Config.webhook.color[Config.webhook.annonce.color.open], "Annonce Ouverture", "Le joueur **"..GetPlayerName(PlayerId()).."** à ouvert le WN")
			end
		end)
		
		Items:AddButton("Fermé !", "Annoncer la fermeture", { IsDisabled = false }, function(onSelected)
			if (onSelected) then
                TriggerServerEvent('rWN:close')
				TriggerEvent('rWN:logs', Config.webhook.url["ferme"], Config.webhook.color[Config.webhook.annonce.color.close], "Annonce Fermeture", "Le joueur **"..GetPlayerName(PlayerId()).."** à fermé le WN")
			end
		end)



		Items:AddLine()

		Items:AddButton("Recrutement", "Recrutements Ouvert", { IsDisabled = false }, function(onSelected)
			if (onSelected) then
                TriggerServerEvent('rWN:recru')
				TriggerEvent('rWN:logs', Config.webhook.url["recrutement"], Config.webhook.color[Config.webhook.annonce.color.recrutement], "Annonce Recrutement", "Le joueur "..GetPlayerName(PlayerId()).." à passé une annonce de recrutement !")
			end
		end)

		
	end, function()
		-- Après le menu (Visuel)
	end)

	Objet:IsVisible(function(Items)
		-- Items
		Items:AddSeparator("↓  ~b~~h~Objet Mobile ~s~ ↓")
		Items:AddButton("Sortir/Ranger Caméra", "Prendre une caméra", { IsDisabled = false }, function(onSelected)
			if (onSelected) then
				ToogleCam()
			end
		end)

		Items:AddButton("Sortir/Ranger Micro", "Prendre un Micro", { IsDisabled = false }, function(onSelected)
			if (onSelected) then
				ToogleMic()
			end
		end)

		Items:AddButton("Sortir/Ranger Micro Perche", "Prendre un micro perche", { IsDisabled = false }, function(onSelected)
			if (onSelected) then
				ToogleBmic()
			end
		end)


		Items:AddSeparator("↓  ~g~~h~Objet Fixe ~s~ ↓")


		Items:AddButton("Fond Vert", "Poser une fond ~g~~h~vert", { IsDisabled = false }, function(onSelected)
			if (onSelected) then
				setPropsFix("prop_ld_greenscreen_01")
			end
		end)

		Items:AddButton("Caméra Fixe", "Poser une caméra", { IsDisabled = false }, function(onSelected)
			if (onSelected) then
				setPropsFix("prop_tv_cam_02")
			end
		end)

		Items:AddButton("Mirco Fixe", "Poser un Micro", { IsDisabled = false }, function(onSelected)
			if (onSelected) then
				setPropsFix("v_ilev_fos_mic")
			end
		end)

		Items:AddButton("Lampe Fixe", "Poser un spot", { IsDisabled = false }, function(onSelected)
			if (onSelected) then
				setPropsFix("prop_kino_light_02")
			end
		end)


		Items:AddSeparator("↓  ~r~~h~Nettoyer La Zone ~s~ ↓")

		
		Items:AddButton("Nettoyer", "Enlever les accessoires dans la zone", { IsDisabled = false }, function(onSelected)
			if (onSelected) then
				cleanArea()
			end
		end)
	end, function()
		-- Après le menu (Visuel)
	end)
end


Keys.Register("F6", "F6", "Menu Journaliste", function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'journalist' then
		RageUI.Visible(MainMenu, not RageUI.Visible(MainMenu))
	end
end)

--[[
	
			Items:AddList("List", { 1, 2, 3 }, ListIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
				if (onListChange) then
					ListIndex = Index;
				end
			end)
]]