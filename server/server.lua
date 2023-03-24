local VORPcore = {}
    TriggerEvent("getCore", function(core)
    VORPcore = core
end)
local authorized = false

CreateThread(function()
    -- Initiate Table
    local result = MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pets` (
        `identifier` varchar(40) NOT NULL,
        `charidentifier` int(11) NOT NULL DEFAULT 0,
        `dog` varchar(255) NOT NULL,
        `skin` int(11) NOT NULL DEFAULT 0,
        UNIQUE KEY `identifier` (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
    ]])
    if not result then
        print("ERROR: Failed to create AFK WL Table")
    end
end)

RegisterServerEvent('bcc:sellpet', function()
    local _source = source
    local User = VORPcore.getUser(_source)
    local Character = User.getUsedCharacter
    local playerid = Character.identifier
    local u_charid = Character.charIdentifier
    MySQL.query("DELETE FROM pets WHERE identifier = @identifier AND charidentifier = @charidentifier", {["identifier"] = playerid, ['charidentifier'] = u_charid})
    TriggerClientEvent('bcc:removedog', _source)
end)

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

RegisterServerEvent('bcc:buydog', function (args)
    local _source   = source
    local User = VORPcore.getUser(_source)
    local Character = User.getUsedCharacter
    local _price = args['Price']
    local _model = args['Model']
    local skin = math.floor(math.random(0, 2))
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    local u_money = Character.money
    if not Config.JobLock then
        if u_money <= _price then
            TriggerClientEvent("vorp:TipRight", _source, _U("NoMoney"), 4000)
            return
        end

        MySQL.query( "SELECT * FROM pets WHERE identifier = @identifier AND charidentifier = @charidentifier", {['identifier'] = u_identifier, ['charidentifier'] = u_charid}, function(result)
            if #result > 0 then
                local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid,  ['dog'] = _model, ['skin'] = skin }
                MySQL.query(" UPDATE pets SET dog = @dog, skin = @skin WHERE identifier = @identifier AND charidentifier = @charidentifier", Parameters, function(r1)
                    Character.removeCurrency(0, _price)
                    TriggerClientEvent('bcc:spawndog', _source, _model, skin, true)
                    TriggerClientEvent("vorp:TipRight", _source, _U("ReplacePet"), 4000)
                end)
            else
                local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid,  ['dog'] = _model, ['skin'] = skin}
                MySQL.query("INSERT INTO pets ( `identifier`,`charidentifier`,`dog`,`skin` ) VALUES ( @identifier,@charidentifier, @dog, @skin )", Parameters, function(r2)
                    Character.removeCurrency(0, _price)
                    TriggerClientEvent('bcc:spawndog', _source, _model, skin, true)
                    TriggerClientEvent("vorp:TipRight", _source, _U("NewPet"), 4000)
                end)
            end
        end)
    else
        for _,v in pairs(Config.JobLock) do
            if Character.job == v then
                authorized = true
            end
        end
        Wait(10)
        if authorized then
            authorized = false
            if u_money <= _price then
                TriggerClientEvent("vorp:TipRight", _source, _U("NoMoney"), 4000)
                return
            end
            MySQL.query( "SELECT * FROM pets WHERE identifier = @identifier AND charidentifier = @charidentifier", {['identifier'] = u_identifier, ['charidentifier'] = u_charid}, function(result)
                if #result > 0 then
                    local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid,  ['dog'] = _model, ['skin'] = skin }
                    MySQL.query(" UPDATE pets SET dog = @dog, skin = @skin WHERE identifier = @identifier AND charidentifier = @charidentifier", Parameters, function(r1)
                        Character.removeCurrency(0, _price)
                        TriggerClientEvent('bcc:spawndog', _source, _model, skin, true)
                        TriggerClientEvent("vorp:TipRight", _source, _U("ReplacePet"), 4000)
                    end)
                else
                    local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid,  ['dog'] = _model, ['skin'] = skin}
                    MySQL.query("INSERT INTO pets ( `identifier`,`charidentifier`,`dog`,`skin` ) VALUES ( @identifier,@charidentifier, @dog, @skin )", Parameters, function(r2)
                        Character.removeCurrency(0, _price)
                        TriggerClientEvent('bcc:spawndog', _source, _model, skin, true)
                        TriggerClientEvent("vorp:TipRight", _source, _U("NewPet"), 4000)
                    end)
                end
            end)
        else
            TriggerClientEvent("vorp:TipRight", _source, _U("NotAuthorized"), 4000)
        end
    end
end)

RegisterNetEvent('bcc-pets:getpets', function()
    local _source = source
    local User = VORPcore.getUser(_source)
    local Character = User.getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local Parameters = {
        ['identifier'] = identifier,
        ['charidentifier'] = charidentifier
    }
    local result = MySQL.query.await("SELECT * FROM pets WHERE identifier = @identifier  AND charidentifier = @charidentifier", Parameters)
    if result then
        for i = 1, #result do
            local row = result[i]
            TriggerClientEvent('bcc-pets:getpetsreturn', _source, row)
        end
    else
        TriggerClientEvent("vorp:TipRight", _source, _U("NoPet"), 4000)
    end
end)

RegisterNetEvent('bcc-pets:transferownership', function(newownerid)
    -- Trading Player
    local _source = source
    local User = VORPcore.getUser(_source)
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    -- Recieving Player
    local UserNew = VORPcore.getUser(newownerid)
    if not UserNew then
        TriggerClientEvent("vorp:TipRight", _source, _U("NotValidOwner"), 4000)
        return
    end
    local CharacterNew = UserNew.getUsedCharacter
    local New_identifier = CharacterNew.identifier
    local New_charid = CharacterNew.charIdentifier

    -- Check if player owns Pet already
    local Parameters1 = {
        ['identifier'] = u_identifier,
        ['charidentifier'] = u_charid,
    }
    local result = MySQL.query.await("SELECT * FROM pets WHERE identifier = @identifier  AND charidentifier = @charidentifier", Parameters1)
    if not result then
        TriggerClientEvent('bcc:removedog', _source)
        local Parameters = {
            ['identifier'] = u_identifier,
            ['charidentifier'] = u_charid,
            ['identifierNEW'] = New_identifier,
            ['charidentifierNEW'] = New_charid,
        }
        MySQL.query(" UPDATE pets SET identifier = @identifierNEW AND charidentifier = @charidentifierNEW WHERE identifier = @identifier AND charidentifier = @charidentifier", Parameters, function()
            TriggerClientEvent("vorp:TipRight", _source, _U("TransferedOwnership"), 4000)
            TriggerClientEvent("vorp:TipRight", newownerid, _U("TransferedOwnershipRecieve"), 4000)
        end)
    else
        TriggerClientEvent("vorp:TipRight", _source, _U("AlreadyHasPet"), 4000)
        TriggerClientEvent("vorp:TipRight", newownerid, _U("YouAlreadyHaveAPet"), 4000)
    end
end)

RegisterServerEvent('bcc:loaddog', function ()
    local _source   = source
    local User = VORPcore.getUser(_source)
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid }
        MySQL.query( "SELECT * FROM pets WHERE identifier = @identifier  AND charidentifier = @charidentifier", Parameters, function(result)
        if result[1] then
            local dog = result[1].dog
            local skin = result[1].skin
            TriggerClientEvent("bcc:spawndog", _source, dog, skin, false)
        else
            TriggerClientEvent("vorp:TipRight", _source, _U("NoPet"), 4000)
        end
    end)
end)
