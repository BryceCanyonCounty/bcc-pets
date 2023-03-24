local recentlySpawned = 0
local currentPetPed = nil
local CurrentZoneActive = 0
local pets = Config.Pets
local shopName = nil
local sleep = 500
local VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
end)

function SetPetAttributes( entity )
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

function CheckAvailability(pet)
	local availability = pet.Availability
	local available = false
	if availability ~= nil then
		for _, peti in pairs(availability) do
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

-- | Functions | --
function SetPetBehavior (petPed)
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

function FollowOwner (currentPetPed, PlayerPedId, isInShop)
	Wait(8500)
	TaskFollowToOffsetOfEntity(currentPetPed, PlayerPedId, 0.0, -1.5, 0.0, 1.0, -1,  Config.PetAttributes.FollowDistance * 100000000, 1, 1, 0, 0, 1)
	Citizen.InvokeNative(0x489FFCCCE7392B55, currentPetPed, PlayerPedId)
end

function SpawnAnimal (model, player, x, y, z, h, skin, PlayerPedId, isdead, isshop)
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
		SetPetBehavior(currentPetPed)
		SetPedAsGroupMember(currentPetPed, GetPedGroupIndex(PlayerPedId))

		while (GetScriptTaskStatus(currentPetPed, 0x4924437d) ~= 8) do
			Wait(1000)
		end

		FollowOwner(currentPetPed, player, isshop)

		if isdead and Config.PetAttributes.Invincible == false then
			TriggerEvent("vorp:TipRight", _U("petHealed"))
		end
	end
end

function SpawnThread()
	CreateThread(function()
		while true do
			Wait(1000)
			if recentlySpawned > 0 then
				recentlySpawned = recentlySpawned - 1
			elseif recentlySpawned <= 0 then
				break
			end
		end
	end)
end

function SET_BLIP_TYPE (animal)
	return Citizen.InvokeNative(0x23f74c2fda6e7c61, -1749618580, animal)
end

function SET_ANIMAL_TUNING_BOOL_PARAM (animal, p1, p2)
	return Citizen.InvokeNative(0x9FF1E042FA597187, animal, p1, p2)
end

function SET_PED_DEFAULT_OUTFIT (dog)
	return Citizen.InvokeNative(0x283978A15512B2FE, dog, true)
end

function SET_PED_OUTFIT_PRESET (dog, preset )
	return Citizen.InvokeNative(0x77FF8D35EEC6BBC4, dog, preset, 0)
end

-- | Threads | --
CreateThread(function()
	for _, info in pairs(Config.Shops) do
		local binfo = info.Blip
        local blip = N_0x554d9d53f696d002(1664425300, binfo.x, binfo.y, binfo.z)
        SetBlipSprite(blip, binfo.sprite, 1)
		SetBlipScale(blip, 0.2)
		Citizen.InvokeNative(0x9CB1A1623062F402, blip, info.Name)
    end
end)

CreateThread(function()
	local PetStores = VORPutils.Prompts:SetupPromptGroup()
    local PetStoresPrompt = PetStores:RegisterPrompt(_U("PromptName"), 0x760A9C6F, 1, 1, false, 'hold', {timedeventhash = "SHORT_TIMED_EVENT"})
    while true do
        sleep = 500
        local coords = GetEntityCoords(PlayerPedId())
            for index, v in pairs(Config.Shops) do
                local dist = #(coords - v.Coords)
                if dist <= 10 then
                    sleep = 5
                end
                if dist < 2.0 then
                    PetStores:ShowGroup(_U("PromptGroupName"))
					shopName = v.Name
					CurrentZoneActive = index
                end
            end
        if PetStoresPrompt:HasCompleted() then
			WarMenu.SetTitle('id_dog', shopName)
			WarMenu.OpenMenu('id_dog')
        end
        Wait(sleep)
    end
end)

CreateThread(function()
	WarMenu.CreateMenu('id_dog', '')
	WarMenu.CreateMenu('pets', '')
	WarMenu.CreateMenu('transfer', '')
	repeat
		if WarMenu.IsMenuOpened('id_dog') then
			if WarMenu.Button(_U('GiveAway')) then
				TriggerServerEvent('bcc:sellpet')
				WarMenu.CloseMenu()
			end
			for i = 1, #pets do
				local acheck = CheckAvailability(pets[i])
				if acheck == true then
					if WarMenu.Button("$"..pets[i]['Param'].Price.." - "..pets[i]['Text'], pets[i]['SubText'], pets[i]['Desc']) then
						TriggerServerEvent('bcc:buydog', pets[i]['Param'])
						WarMenu.CloseMenu()
					end
				end
			end
			WarMenu.Display()
		end
		if WarMenu.IsMenuOpened('pets') then
			if WarMenu.Button(_U('CallPet')) then
				TriggerServerEvent('bcc:loaddog')
				WarMenu.CloseMenu()
			end
			if WarMenu.Button(_U('PutAwayPet')) then
				TriggerEvent('bcc:putaway')
				WarMenu.CloseMenu()
			end
			if WarMenu.Button(_U('TransferOwnership')) then
				TriggerServerEvent('bcc-pets:getpets')
				WarMenu.CloseMenu()
			end
			WarMenu.Display()
		end
		if WarMenu.IsMenuOpened('transfer') then
			for i = 1, #pets do
				if pets[i]['Param'].Model == PlayerPets.dog then
					if WarMenu.Button(pets[i]['Text'], pets[i]['SubText'], pets[i]['Desc']) then
						TriggerEvent('bcc-pets:transferpetinput', pets[i]['Param'])
						WarMenu.CloseMenu()
						PlayerPets = {}
					end
				end
			end
			WarMenu.Display()
		end
		Wait(0)
	until false
end)

-- | Transfer Pet | --
RegisterNetEvent('bcc-pets:transferpetinput', function(pet)
	local button = "Confirm"
	local placeholder = "Insert Person's ID #"
    TriggerEvent("vorpinputs:getInput", button, placeholder, function(result)
        if result ~= "" or result then -- making sure its not empty or nil
            TriggerServerEvent('bcc-pets:transferownership', result, pet)
        else
			TriggerEvent("vorp:TipRight", _U("RequireID"), 4000)
        end
    end)
end)

RegisterNetEvent('bcc-pets:getpetsreturn', function(result)
	PlayerPets = result
	Wait(1000)
	WarMenu.SetTitle('transfer', _U("PetMenu"))
	WarMenu.OpenMenu('transfer')
end)

-- | Remove Pet | --
RegisterNetEvent('bcc:removedog', function ()
	if currentPetPed then
		DeleteEntity(currentPetPed)
		TriggerEvent("vorp:TipRight", _U("ReleasePet"))
	end
end)

RegisterNetEvent('bcc:putaway', function ()
	if currentPetPed then
		TaskAnimalFlee(currentPetPed, PlayerPedId(), -1)
		TriggerEvent("vorp:TipRight", _U("PetAway"))
		Wait(5000)
		DeleteEntity(currentPetPed)
	end
end)

-- | Spawn Pet | --
RegisterNetEvent('bcc:spawndog', function ( dog, skin, isInShop )
	if recentlySpawned <= 0 then
		recentlySpawned = Config.PetAttributes.SpawnLimiter
		SpawnThread()
	else
		TriggerEvent("vorp:TipRight", _U("SpawnLimiter"))
		return
	end

	local player = PlayerPedId()
	local model = GetHashKey( dog )
	local x, y, z, heading, b, w

	-- Set initial pet location
	if isInShop then
		x, y, z, heading = -373.302, 786.904, 116.169, 273.18
	else
		x, y, z = table.unpack( GetOffsetFromEntityInWorldCoords( player, 0.0, -5.0, 0.3 ) )
		b = GetGroundZAndNormalFor_3dCoord( x, y, z + 10 )
	end

	RequestModel( model )

	while not HasModelLoaded( model ) do
		Wait(500)
	end

	if isInShop then
		x, y, z, w = table.unpack(Config.Shops[CurrentZoneActive].SpawnPet)
		SpawnAnimal(model, player, x, y, z, w, skin, PlayerPedId(), false, true)
	else
		local EntityIsDead = false
		if (currentPetPed ~= nil) then
			EntityIsDead = IsEntityDead( currentPetPed )
		end

		if EntityIsDead then
			SpawnAnimal(model, player, x, y, b, heading, skin, PlayerPedId(), true, false)
		else
			SpawnAnimal(model, player, x, y, b, heading, skin, PlayerPedId(), false, false)
		end
	end
end)

-- | Commands | --
RegisterCommand(Config.Commands.FleePet, function()
	TriggerEvent('bcc:putaway')
end)

RegisterCommand(Config.Commands.CallPet, function()
	TriggerServerEvent('bcc:loaddog')
end)

RegisterCommand(Config.Commands.PetMenu, function()
	WarMenu.SetTitle('pets', _U("PetMenu"))
	WarMenu.OpenMenu('pets')
end)
