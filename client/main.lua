local piss = false
local poo = false
local shower = false

RegisterCommand("mear", function()
	if piss == false then
		piss = true
		TriggerEvent("skinchanger:getSkin", function(skin)
			if skin.sex == 0 then
				exports["mythic_progressbar"]:Progress({
					name = "piss",
					duration = 8000,
					label = "Meando...",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = "misscarsteal2peeing",
						anim = "peeing_loop",
						flags = 8,
					},
				}, function(cancelled)
					if not cancelled then
						piss = false
						TriggerEvent("esx_status:set", "piss", 1000000)
						exports["mythic_notify"]:SendAlert("inform", "Orinaste con éxito", 5000)
					else
						piss = false
					end
				end)
			else
				exports["mythic_progressbar"]:Progress({
					name = "piss",
					duration = 8000,
					label = "Meando...",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = "missfbi3ig_0",
						anim = "shit_loop_trev",
						flags = 8,
					},
				}, function(cancelled)
					if not cancelled then
						piss = false
						TriggerEvent("esx_status:set", "piss", 1000000)
						exports["mythic_notify"]:SendAlert("inform", "Orinaste con éxito", 5000)
					else
						piss = false
					end
				end)
			end
		end)		
	else
		exports["mythic_notify"]:SendAlert("inform", "Ya orinaste", 5000)
	end
end)

RegisterCommand("caca", function()
	if poo == false then
        local player = PlayerPedId()
		poo = true
		exports["mythic_progressbar"]:Progress({
			name = "poo",
			duration = 8000,
			label = "Cagando...",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "missfbi3ig_0",
				anim = "shit_loop_trev",
				flags = 8,
			},
		}, function(cancelled)
			if not cancelled then
				poo = false
				TriggerEvent("esx_status:set", "poop", 1000000)
				exports["mythic_notify"]:SendAlert("inform", "Cagaste con éxito", 5000)
			else
				poo = false
			end
		end)			
	else
		exports["mythic_notify"]:SendAlert("inform", "Ya haces caca", 5000)
	end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(5000)
        local player = PlayerPedId()
		local inwater = IsEntityInWater(player)
		if inwater then
			TriggerEvent("esx_status:getStatus", "hygiene", function(status)
				if status.val <= 1000000 then
					TriggerEvent("esx_status:add", "hygiene", 50000)
					exports["mythic_notify"]:SendAlert("inform", "Te están limpiando porque estás en el agua", 5000)
				end
			end)
		else
			Citizen.Wait(5000)
		end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		local player  = PlayerPedId()
		local health = GetEntityHealth(player)
		local newhealth = health

		TriggerEvent("esx_status:getStatus", "piss", function(status)
			if status.val == 0 then
				if prevHealth <= 50 then
					newhealth = newhealth - 5
					exports["mythic_notify"]:SendAlert("inform", "Necesitas orinar", 5000)
				else
					newhealth = newhealth - 1
				end
			end
		end)

		TriggerEvent("esx_status:getStatus", "poop", function(status)
			if status.val == 0 then
				if prevHealth <= 50 then
					newhealth = newhealth - 5
					exports["mythic_notify"]:SendAlert("inform", "Necesitas hacer caca", 5000)
				else
					newhealth = newhealth - 1
				end
			end
		end)
		
		TriggerEvent("esx_status:getStatus", "hygiene", function(status)
			if status.val == 0 then
				if prevHealth <= 50 then
					newhealth = newhealth - 5
					exports["mythic_notify"]:SendAlert("inform", "Estás sucio", 5000)
					SetPedWetnessEnabledThisFrame(player)
					SetPedWetnessHeight(player, 10.0)					
				else
					newhealth = newhealth - 1
				end
			end
		end)		

		if newhealth ~= prevHealth then
			SetEntityHealth(playerPed, newhealth)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local coords = GetEntityCoords(PlayerPedId())
		local letSleep = true
		for i, showerdata in ipairs(Config.Showers) do
			local distance = #(showerdata.coords - coords)
			if distance < 5 and shower == false then
				letSleep = false
				DrawText3D(showerdata.coords.x, showerdata.coords.y, showerdata.coords.z, "Presiona [E] para ducharte")
			end
		end		

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

function DrawText3D(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords()) 
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 240
		DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 255, 102, 255, 150)
	end
end

RegisterNetEvent("oa_vida:showersynchclient")
AddEventHandler("oa_vida:showersynchclient", function(targetped)  
    local targetplayer = GetPlayerPed(GetPlayerFromServerId(targetped))
	local pos = GetEntityCoords(targetplayer)
    local particleDictionary = "scr_mp_house"
    local particleName = "ent_amb_shower"	
    RequestNamedPtfxAsset(particleDictionary)

    while not HasNamedPtfxAssetLoaded(particleDictionary) do
        Citizen.Wait(0)
    end

    SetPtfxAssetNextCall(particleDictionary)

	local effect = StartParticleFxLoopedAtCoord(particleName, pos.x, pos.y, pos.z+2, -50.00, 0.0, 0.0, 2.0, true, false, false, 0)
end)

RegisterNetEvent("oa_vida:showerdisableclient")
AddEventHandler("oa_vida:showerdisableclient", function(posx, posy, posz)  
    RemoveParticleFxInRange(posx, posy, posz, 5.0)
end)

function ShowerUse()
	local player  = PlayerPedId()
	local pos = GetEntityCoords(player)
	shower = true
	TriggerServerEvent("oa_vida:showersynchserver", GetPlayerServerId(PlayerId()))
	exports["mythic_progressbar"]:Progress({
		name = "shower",
		duration = 10000,
		label = "duchandote...",
		useWhileDead = true,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "mp_safehouseshower@female@",
			anim = "shower_idle_a",
			flags = 49,
		},
		prop = {
			model = "prop_toilet_soap_01",
			bone = 57005,
			coords = { x = 0.10, y = 0.02, z = -0.01 },
			rotation = { x = 200.0, y = -20.0, z = 90.0 },
		},
	}, function(cancelled)
		if not cancelled then
			shower = false
			ClearPedEnvDirt(player)
			ClearPedBloodDamage(player)			
			TriggerServerEvent("oa_vida:showerdisableserver", pos.x, pos.y, pos.z)
			TriggerEvent("esx_status:set", "hygiene", 1000000)
			exports["mythic_notify"]:SendAlert("inform", "Te duchaste con éxito", 5000)			
		else
			shower = false
			TriggerServerEvent("oa_vida:showerdisableserver", pos.x, pos.y, pos.z)
		end
	end)
end

RegisterCommand("showeruse", function()
	if shower == false then
		local coords = GetEntityCoords(PlayerPedId())
		local foundshower = false
		for i, showerdata in ipairs(Config.Showers) do
			local distance = #(showerdata.coords - coords)
			if distance < 5 then	
				foundshower = true
			end
		end	
		if foundshower then
			ShowerUse()
		end
	else
		exports["mythic_notify"]:SendAlert("inform", "Ya estás en la ducha", 5000)
	end
end) 

RegisterKeyMapping("showeruse", "showeruse", "keyboard", "e")
