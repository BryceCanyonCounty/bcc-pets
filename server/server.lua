-- VORP
local VorpCore = {}
TriggerEvent("getCore",function(core)
    VorpCore = core
end)
VORP = exports.vorp_core:vorpAPI()

CreateThread(function()
    -- Initiate Table
    local result = MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pets` (
            `petid` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(40) NOT NULL,
            `charidentifier` int(11) NOT NULL DEFAULT 0,
            `dog` varchar(255) NOT NULL,
            `skin` int(11) NOT NULL DEFAULT 0,
            `xp` int(11) NOT NULL DEFAULT 0,
            `transfered` int(11) NOT NULL DEFAULT 0,
            `called` int(11) NOT NULL DEFAULT 0,
            KEY `petid` (`petid`)
            ) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]])
    if not result then
        print("ERROR: Failed to create AFK WL Table")
    end
end)

RegisterServerEvent('bcc-pets:sellpet', function(petid, SellPrice)
    local _source = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local u_charid = Character.charIdentifier
    Character.addCurrency(0, SellPrice)
    MySQL.query("DELETE FROM pets WHERE charidentifier = @charidentifier AND petid = @petid", {['charidentifier'] = u_charid, ["petid"] = petid})
    TriggerClientEvent('bcc-pets:removedog', _source, petid)
    VorpCore.NotifyRightTip(_source, _U("SoldPet")..SellPrice, 5000)
end)

RegisterServerEvent('bcc-pets:buydog', function (args, ShopID)
    local _source   = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local _price = args['Price']
    local _model = args['Model']
    local skin = math.floor(math.random(0, 2))
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    local u_money = Character.money
    if u_money <= _price then
        VorpCore.NotifyRightTip(_source, _U("NoMoney"), 5000)
        return
    end
    local result = MySQL.query.await( "SELECT * FROM pets WHERE identifier = @identifier AND charidentifier = @charidentifier", {['identifier'] = u_identifier, ['charidentifier'] = u_charid})
    if #result <= Config.MaxPets then
        local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid,  ['dog'] = _model, ['skin'] = skin, ['called'] = 1}
        local BuyPet = MySQL.insert.await("INSERT INTO pets ( `identifier`,`charidentifier`,`dog`,`skin`,`called` ) VALUES ( @identifier,@charidentifier, @dog, @skin, @called )", Parameters)
            if BuyPet then
                Character.removeCurrency(0, _price)
                TriggerClientEvent('bcc-pets:spawndog', _source, _model, skin, true, BuyPet, ShopID)
                VorpCore.NotifyRightTip(_source, _U("NewPet"), 5000)
            else
                VorpCore.NotifyRightTip(_source, _U("IssueBuying"), 5000)
            end
    else
        VorpCore.NotifyRightTip(_source, _U("YouAlreadyHaveAPet"), 5000)
    end
end)

RegisterServerEvent('bcc-pets:transferownership', function(newownerid, petid)
    -- Trading Player
    local _source = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    -- Check if player owns Pet already
    local Parameters1 = {
        ['identifier'] = u_identifier,
        ['charidentifier'] = u_charid
    }
    local result = MySQL.query.await("SELECT * FROM pets WHERE identifier = @identifier  AND charidentifier = @charidentifier", Parameters1)
       if result then
        if #result <= Config.MaxPets then
            TriggerClientEvent('bcc-pets:removedog', _source, petid)
            -- Recieving Player
            local UserNew = VorpCore.getUser(newownerid)
            local CharacterNew = UserNew.getUsedCharacter
            local New_identifier = CharacterNew.identifier
            local New_charid = CharacterNew.charIdentifier
            local TransferPet = MySQL.update.await("UPDATE pets SET identifier = ?, charidentifier = ?, transfered = ? WHERE petid = ?", {New_identifier, New_charid, 1, petid})
            if TransferPet then
                VorpCore.NotifyRightTip(_source, _U("TransferedOwnership"), 5000)
                VorpCore.NotifyRightTip(newownerid, _U("TransferedOwnershipRecieve"), 5000)
            else
                VorpCore.NotifyRightTip(_source, _U("IssueTransferring"), 5000)
                VorpCore.NotifyRightTip(newownerid, _U("IssueTransferring"), 5000)
            end
        else
            VorpCore.NotifyRightTip(_source, _U("AlreadyHasPet"), 5000)
            VorpCore.NotifyRightTip(newownerid, _U("YouAlreadyHaveAPet"), 5000)
        end
    else
        VorpCore.NotifyRightTip(_source, _U("IssueTransferring"), 5000)
        VorpCore.NotifyRightTip(newownerid, _U("IssueTransferring"), 5000)
    end
end)

RegisterServerEvent('bcc-pets:callpet', function(petid)
    local _source   = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    local Parameters1 = {
        ['identifier'] = u_identifier,
        ['charidentifier'] = u_charid,
        ['petid'] = petid
    }
    local result = MySQL.query.await("SELECT * FROM pets WHERE identifier = @identifier AND charidentifier = @charidentifier AND petid = @petid", Parameters1)
    if result then
        MySQL.update('UPDATE pets SET called = ? WHERE petid = ?', {1, petid}, function(UpdateOutStatus)
            if UpdateOutStatus then
                local dog = result[1].dog
                local skin = result[1].skin
                TriggerClientEvent("bcc-pets:spawndog", _source, dog, skin, false, petid)
                VorpCore.NotifyRightTip(_source,_U("CalledPet")..Config.Pets[dog][1].Text, 5000)
            end
        end)
    else
        VorpCore.NotifyRightTip(_source,_U("NoPet"), 5000)
    end
end)

RegisterServerEvent('bcc-pets:server:putawaypet', function(petid)
    local _source = source
    local UpdateOutStatus = MySQL.update.await('UPDATE pets SET called = ? WHERE petid = ?', {0, petid})
    if UpdateOutStatus then
        VorpCore.NotifyRightTip(_source,_U("PetAway"), 5000)
    end
end)

VorpCore.addRpcCallback("GetPlayersPets", function(source, cb)
    local _source = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    local Parameters1 = {
        ['identifier'] = u_identifier,
        ['charidentifier'] = u_charid,
    }
    local result = MySQL.query.await('SELECT * FROM pets WHERE identifier = @identifier AND charidentifier = @charidentifier', Parameters1)
    if result then
        cb(result)
    else
        cb(false)
    end
end)

if Config.PetMenu.active then
    RegisterCommand(Config.PetMenu.command, function(source)
        TriggerClientEvent('bcc-pets:openpetmenu', source)
    end)
end