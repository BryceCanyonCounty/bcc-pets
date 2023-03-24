Config = {}
Config.Locale = "en"

Config.JobLock = false -- Set to false if no job lock is wanted. Ex - {'vetanarian'} or {'blackwatervetanarian', 'valentinevetanarian'}
Config.Commands = {
    PetMenu = 'pet', -- Command to open Pet Menu
    CallPet = 'callpet', -- Command to directly call active pet
    FleePet = 'fleepet', -- Command to send active pet home
}

Config.Shops = {
    {
        Name = 'Shelter', -- Blip name and Shop name
        Coords = vector3(-273.894287109375, 685.2567138671875, 113.41388702392578),
        SpawnPet = vector4( -284.09, 685.34, 113.59, 234.45 ),
        Blip = { sprite = -1646261997, x = -273.51, y = 689.26, z = 113.41 }
    },
}

Config.PetAttributes = {
    FollowDistance = 5,
    Invincible = true,
    SpawnLimiter = 2 -- Set to 0 if you do not want a spawn limiter
}

Config.Pets = {
    {
        Text = "BullFrog",
        SubText = "",
        Desc = "Ribbet Ribbet",
        Param = {
            Price = 30,
            Model = "a_c_frogbull_01",
            Level = 1
        },
        Availability = {
            1
        }
    },
    {
        Text = "Husky",
        SubText = "",
        Desc = "Best pet you'll ever have",
        Param = {
            Price = 200,
            Model = "A_C_DogHusky_01",
            Level = 1
        }
    },
    {
        Text = "Mutt",
        SubText = "",
        Desc = "Best pet you'll ever have",
        Param = {
            Price = 50,
            Model = "A_C_DogCatahoulaCur_01",
            Level = 1
        }
    },
    {
        Text = "Labrador Retriever",
        SubText = "",
        Desc = "Best pet you'll ever have",
        Param = {
            Price = 100,
            Model = "A_C_DogLab_01",
            Level = 1
        }
    },
    {
        Text = "Rufus",
        SubText = "",
        Desc = "Best pet you'll ever have",
        Param = {
            Price = 100,
            Model = "A_C_DogRufus_01",
            Level = 1
        }
    },
    {
        Text = "Blue Hound",
        SubText = "",
        Desc = "Best pet you'll ever have",
        Param = {
            Price = 150,
            Model = "A_C_DogBluetickCoonhound_01",
            Level = 1
        }
    },
        {
        Text = "Hound Dog",
        SubText = "",
        Desc = "Best pet you'll ever have",
        Param = {
            Price = 150,
            Model = "A_C_DogHound_01",
            Level = 1
        }
    },
    {
        Text = "Border Collie",
        SubText = "",
        Desc = "Best pet you'll ever have",
        Param = {
            Price = 200,
            Model = "A_C_DogCollie_01",
            Level = 1
        }
    },
    {
        Text = "Poodle",
        SubText = "",
        Desc = "Best pet you'll ever have",
        Param = {
            Price = 200,
            Model = "A_C_DogPoodle_01",
            Level = 1
        }
    },

    {
        Text = "Foxhound",
        SubText = "",
        Desc = "Best pet you'll ever have",
        Param = {
            Price = 100,
            Model = "A_C_DogAmericanFoxhound_01",
            Level = 1
        }
    },
    {
        Text = "Australian Shephard",
        SubText = "",
        Desc = "Best pet you'll ever have",
        Param = {
            Price = 100,
            Model = "A_C_DogAustralianSheperd_01",
            Level = 1
        }
    },
    {
        Text = "Cat",
        SubText = "",
        Desc = "Best pet you'll ever have",
        Param = {
            Price = 100,
            Model = "A_C_Cat_01",
            Level = 1
        }
    }
}

Config.Keys = { ["B"] = 0x4CC0E2FE, ['S'] = 0xD27782E3, ['W'] = 0x8FD015D8, ['H'] = 0x24978A28, ['G'] = 0x5415BE48, ["ENTER"] = 0xC7B5340A, ['E'] = 0xDFF812F9, ["J"] = 0xF3830D8E }
