-- Based on Malik's and Blue's animal shelters and vorp animal shelter --

local keys = Config.Keys

local pressTime = 0
local pressLeft = 0

local recentlySpawned = 0

local currentPetPed = nil;

local CurrentZoneActive = 0

local pets = Config.Pets

Citizen.CreateThread(function()
	for _, info in pairs(Config.Shops) do
		local binfo = info.Blip
        local blip = N_0x554d9d53f696d002(1664425300, binfo.x, binfo.y, binfo.z)
        SetBlipSprite(blip, binfo.sprite, 1)
		SetBlipScale(blip, 0.2)
		Citizen.InvokeNative(0x9CB1A1623062F402, blip, info.Name)
    end  
end)

local function SetPetAttributes( entity )
    -- | SET_ATTRIBUTE_POINTS | --
    Citizen.InvokeNative( 0x09A59688C26D88DF, entity, 0, 1100 )
    Citizen.InvokeNative( 0x09A59688C26D88DF, entity, 1, 1100 )
    Citizen.InvokeNative( 0x09A59688C26D88DF, entity, 2, 1100 )
    -- | ADD_ATTRIBUTE_POINTS | --
    Citizen.InvokeNative( 0x75415EE0CB583760, entity, 0, 1100 )
    Citizen.InvokeNative( 0x75415EE0CB583760, entity, 1, 1100 )
    Citizen.InvokeNative( 0x75415EE0CB583760, entity, 2, 1100 )
    -- | SET_ATTRIBUTE_BASE_RANK | --
    Citizen.InvokeNative( 0x5DA12E025D47D4E5, entity, 0, 10 )
    Citizen.InvokeNative( 0x5DA12E025D47D4E5, entity, 1, 10 )
    Citizen.InvokeNative( 0x5DA12E025D47D4E5, entity, 2, 10 )
    -- | SET_ATTRIBUTE_BONUS_RANK | --
    Citizen.InvokeNative( 0x920F9488BD115EFB, entity, 0, 10 )
    Citizen.InvokeNative( 0x920F9488BD115EFB, entity, 1, 10 )
    Citizen.InvokeNative( 0x920F9488BD115EFB, entity, 2, 10 )
    -- | SET_ATTRIBUTE_OVERPOWER_AMOUNT | --
    Citizen.InvokeNative( 0xF6A7C08DF2E28B28, entity, 0, 5000.0, false )
    Citizen.InvokeNative( 0xF6A7C08DF2E28B28, entity, 1, 5000.0, false )
    Citizen.InvokeNative( 0xF6A7C08DF2E28B28, entity, 2, 5000.0, false )
end

local function IsNearZone ( location, distance, ring )

	local player = PlayerPedId()
	local playerloc = GetEntityCoords(player, 0)

	for i = 1, #location do
		if #(playerloc - location[i]) < distance then
			if ring == true then
				Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, location[i].x, location[i].y, location[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.0, 100, 1, 1, 190, false, true, 2, false, false, false, false)
			end
			return true, i
		end
	end

end

local function DisplayHelp( _message, x, y, w, h, enableShadow, col1, col2, col3, a, centre )

	local str = CreateVarString(10, "LITERAL_STRING", _message, Citizen.ResultAsLong())

	SetTextScale(w, h)
	SetTextColor(col1, col2, col3, a)

	SetTextCentre(centre)

	if enableShadow then
		SetTextDropshadow(1, 0, 0, 0, 255)
	end

	Citizen.InvokeNative(0xADA9255D, 10);

	DisplayText(str, x, y)

end

local function ShowNotification( _message )
	local timer = 200
	while timer > 0 do
		DisplayHelp(_message, 0.50, 0.90, 0.6, 0.6, true, 161, 3, 0, 255, true)
		timer = timer - 1
		Citizen.Wait(0)
	end
end

local function checkAvailability(pet) 
	local availability = pet.Availability

	local available = false

	if availability ~= nil then 
		for index, peti in pairs(availability) do
			if peti == CurrentZoneActive then
				available = true
				return available
			end
		end
	else
		available = true
	end

	return available

end

Citizen.CreateThread( function()
	WarMenu.CreateMenu('id_dog', '')
	repeat
		if WarMenu.IsMenuOpened('id_dog') then
			if WarMenu.Button(_U('GiveAway')) then
				TriggerServerEvent('bcc:sellpet')
				WarMenu.CloseMenu()
			end

			local shop = Config.Shops[CurrentZoneActive]

			for i = 1, #pets do
				local acheck = checkAvailability(pets[i])
				if acheck == true then
					if WarMenu.Button(pets[i]['Text'], pets[i]['SubText'], pets[i]['Desc']) then
						TriggerServerEvent('bcc:buydog', pets[i]['Param'])
						WarMenu.CloseMenu()
					end
				end
			end
			WarMenu.Display()
		end
		Citizen.Wait(0)
	until false
end)

Citizen.CreateThread(function()
	while true do
		for index, shop in pairs(Config.Shops) do
			local IsZone, IdZone = IsNearZone( shop.Coords, shop.ActiveDistance, shop.Ring )
			-- Shop control and menu open
			if IsZone then
				DisplayHelp(_U('Shoptext'), 0.50, 0.95, 0.6, 0.6, true, 255, 255, 255, 255, true)
				if IsControlJustPressed(0, keys[Config.TriggerKeys.OpenShop]) then
					WarMenu.SetTitle('id_dog', shop.Name)
					WarMenu.OpenMenu('id_dog')
					CurrentZoneActive = index
				end
			end
		end


		if Config.CallPetKey == true then
			if IsControlJustReleased(0, keys[Config.TriggerKeys.CallPet]) then
				pressLeft = GetGameTimer()
				pressTime = pressTime + 1
			end
	
			if pressLeft ~= nil and (pressLeft + 500) < GetGameTimer() and pressTime > 0 and pressTime < 1 then
				pressTime = 0
			end
	
			if pressTime == 1 then
				TriggerServerEvent('bcc:loaddog')
				pressTime = 0
			end
		end

		Citizen.Wait(0)
	end
end)


-- | Notification | --

RegisterNetEvent('UI:DrawNotification')
AddEventHandler('UI:DrawNotification', function( _message )
	ShowNotification( _message )
end)

-- | Remove Dog | --

RegisterNetEvent( 'bcc:removedog' )
AddEventHandler( 'bcc:removedog', function (args)
	if currentPetPed then
		DeleteEntity(currentPetPed)
		ShowNotification(_U('ReleasePet'))
	end
end)

RegisterNetEvent( 'bcc:putaway' )
AddEventHandler( 'bcc:putaway', function (args)
	if currentPetPed then
		DeleteEntity(currentPetPed)
		ShowNotification(_U('PetAway'))
	end
end)

RegisterCommand("fleepet", function(source, args, rawCommand) --  COMMAND
    local _source = source
    local ped = PlayerPedId()
	TriggerEvent('bcc:putaway')


end)

RegisterCommand("callpet", function(source, args, rawCommand) --  COMMAND
    local _source = source
    local ped = PlayerPedId()
	TriggerServerEvent('bcc:loaddog')


end)

-- | Spawn dog | --

function setPetBehavior (petPed)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 143493179)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -2040077242)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 1222652248)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 1077299173)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -887307738)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -1998572072)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -661858713)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 1232372459)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -1836932466)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 1878159675)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 1078461828)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -1535431934)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 1862763509)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -1663301869)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -1448293989)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -1201903818)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -886193798)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -1996978098)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 555364152)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -2020052692)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 707888648)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 378397108)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -350651841)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -1538724068)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 1030835986)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -1919885972)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -1976316465)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 841021282)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 889541022)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -1329647920)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -319516747)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -767591988)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -989642646)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), 1986610512)
	SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(petPed), -1683752762)
end

function followOwner (currentPetPed, PlayerPedId, isInShop)
	TaskFollowToOffsetOfEntity(currentPetPed, PlayerPedId, 0.0, -1.5, 0.0, 1.0, -1,  Config.PetAttributes.FollowDistance * 100000000, 1, 1, 0, 0, 1)
	if isInShop then
		Citizen.InvokeNative(0x489FFCCCE7392B55, currentPetPed, PlayerPedId)
	end
end

function spawnAnimal (model, player, x, y, z, h, skin, PlayerPedId, isdead, isshop) 
	local EntityPedCoord = GetEntityCoords( player )
	local EntitydogCoord = GetEntityCoords( currentPetPed )
	if #( EntityPedCoord - EntitydogCoord ) > 100.0 or isshop or isdead then
		if currentPetPed ~= nil then
			DeleteEntity(currentPetPed)
		end

		currentPetPed = CreatePed(model, x, y, z, h, 1, 1 )
		SET_PED_OUTFIT_PRESET( currentPetPed, skin )
		SET_BLIP_TYPE( currentPetPed )
		
		if Config.PetAttributes.Invincible then
			SetEntityInvincible(currentPetPed, true)
		end

		SetPetAttributes(currentPetPed)
		setPetBehavior(currentPetPed)
		SetPedAsGroupMember(currentPetPed, GetPedGroupIndex(PlayerPedId))
	
		while (GetScriptTaskStatus(currentPetPed, 0x4924437d) ~= 8) do
			Wait(1000)
		end
	
		followOwner(currentPetPed, player, isshop)
	
		if isdead and Config.PetAttributes.Invincible == false then
			ShowNotification( _U('petHealed') )
		end
	end
end

RegisterNetEvent( 'bcc:spawndog' )
AddEventHandler( 'bcc:spawndog', function ( dog, skin, isInShop )
	if recentlySpawned <= 0 then
		recentlySpawned = Config.PetAttributes.SpawnLimiter
	else
		ShowNotification( _U('SpawnLimiter') )
		return
	end


	local player = PlayerPedId()

	local model = GetHashKey( dog )
	local x, y, z, heading, a, b

	-- Set initial pet location
	if isInShop then
		x, y, z, heading = -373.302, 786.904, 116.169, 273.18
	else
		x, y, z = table.unpack( GetOffsetFromEntityInWorldCoords( player, 0.0, -5.0, 0.3 ) )
		a, b = GetGroundZAndNormalFor_3dCoord( x, y, z + 10 )
	end

	RequestModel( model )

	while not HasModelLoaded( model ) do
		Wait(500)
	end

	if isInShop then
		local x, y, z, w = table.unpack(Config.Shops[CurrentZoneActive].Spawndog)
		spawnAnimal(model, player, x, y, z, w, skin, PlayerPedId(), false, true) 
	else
		local EntityIsDead = false
		if (currentPetPed ~= nil) then
			EntityIsDead = IsEntityDead( currentPetPed )
		end

		if EntityIsDead then
			spawnAnimal(model, player, x, y, b, heading, skin, PlayerPedId(), true, false)
		else
			spawnAnimal(model, player, x, y, b, heading, skin, PlayerPedId(), false, false) 
		end
	end
end)




function SET_BLIP_TYPE ( animal )
	return Citizen.InvokeNative(0x23f74c2fda6e7c61, -1749618580, animal)
end

function SET_ANIMAL_TUNING_BOOL_PARAM ( animal, p1, p2 )
	return Citizen.InvokeNative( 0x9FF1E042FA597187, animal, p1, p2 )
end

function SET_PED_DEFAULT_OUTFIT ( dog )
	return Citizen.InvokeNative( 0x283978A15512B2FE, dog, true )
end

function SET_PED_OUTFIT_PRESET ( dog, preset )
	return Citizen.InvokeNative( 0x77FF8D35EEC6BBC4, dog, preset, 0 )
end

-- | Timer | --

 Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
		if recentlySpawned > 0 then
			recentlySpawned = recentlySpawned - 1
		end
    end
end)


