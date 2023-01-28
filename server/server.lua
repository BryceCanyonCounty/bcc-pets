local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

Citizen.CreateThread(function()
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
    if result and result.warningStatus > 1 then
        print("ERROR: Failed to create AFK WL Table")
    end
end)


RegisterServerEvent('bcc:sellpet')
AddEventHandler('bcc:sellpet', function()
    TriggerEvent("vorp:getCharacter", source, function(user)
        local User = VorpCore.getUser(source)
        local Character = User.getUsedCharacter
        local playerid = Character.identifier
        local u_charid = Character.charIdentifier
        local _src = source
        MySQL.query("DELETE FROM pets WHERE identifier = @identifier AND charidentifier = @charidentifier", {["identifier"] = playerid, ['charidentifier'] = u_charid})
        TriggerClientEvent('bcc:removedog', _src)
    end)
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

RegisterServerEvent('bcc:buydog')
AddEventHandler( 'bcc:buydog', function ( args )
    local _src   = source
    local User = VorpCore.getUser(_src)
    local Character = User.getUsedCharacter
    local _price = args['Price']
    local _model = args['Model']
    local skin = math.floor(math.random(0, 2))

    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    local u_money = Character.money

    if u_money <= _price then
        TriggerClientEvent( 'UI:DrawNotification', _src, _U('NoMoney') )
        return
    end

    MySQL.query( "SELECT * FROM pets WHERE identifier = @identifier AND charidentifier = @charidentifier", {['identifier'] = u_identifier, ['charidentifier'] = u_charid}, function(result)
        if #result > 0 then
            local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid,  ['dog'] = _model, ['skin'] = skin }
            MySQL.query(" UPDATE pets SET dog = @dog, skin = @skin WHERE identifier = @identifier AND charidentifier = @charidentifier", Parameters, function(r1)
                Character.removeCurrency(0, _price)
                TriggerClientEvent('bcc:spawndog', _src, _model, skin, true)
                TriggerClientEvent( 'UI:DrawNotification', _src, _U('ReplacePet') )
            end)
        else
            local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid,  ['dog'] = _model, ['skin'] = skin}
            MySQL.query("INSERT INTO pets ( `identifier`,`charidentifier`,`dog`,`skin` ) VALUES ( @identifier,@charidentifier, @dog, @skin )", Parameters, function(r2)
                Character.removeCurrency(0, _price)
                TriggerClientEvent('bcc:spawndog', _src, _model, skin, true)
                TriggerClientEvent( 'UI:DrawNotification', _src, _U('NewPet') )
            end)
        end
    end)
end)

RegisterServerEvent( 'bcc:loaddog' )
AddEventHandler( 'bcc:loaddog', function ( )
    local _src   = source
    local User = VorpCore.getUser(_src)
    local Character = User.getUsedCharacter

    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier

    local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid }
    MySQL.query( "SELECT * FROM pets WHERE identifier = @identifier  AND charidentifier = @charidentifier", Parameters, function(result)
        if result[1] then
            local dog = result[1].dog
            local skin = result[1].skin
            TriggerClientEvent("bcc:spawndog", _src, dog, skin, false)
        else
            TriggerClientEvent( 'UI:DrawNotification', _src, _U('NoPet') )
        end
    end)
end)