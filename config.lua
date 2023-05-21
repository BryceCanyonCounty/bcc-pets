-- Based on Malik's and Blue's animal shelters and vorp animal shelter --


Config = {}

Config.Locale = "en"                    -- en

Config.AllowMultipleTrades = false      -- Allow a pet to be traded more than once
Config.MaxPets = 5                      -- Max number of pets a player can own
Config.CallPetHotKey = {
    active = false,
    key = 0xDFF812F9
}
Config.PetMenu = {
    active = true,
    command = 'pet',                        -- Command to open Pet Menu
    animation = true,                       -- Opening book scenario
}

Config.PetAttributes = {
    FollowDistance = 5,
    Invincible = true,
}

Config.SellPercentage = 30                  -- % of the pet price the player recieves for selling back to Shops
Config.ShopsPromptKey = 0x760A9C6F          -- Hash of the Key used to access the Shop locations
Config.ShopsPromptText = "Shop for a pet"
Config.ShopsPromptDistance = 2.0            -- Should not be larger than 10
Config.Shops = {
    {
        Name = 'Pet Shelter',               -- Name on blip and prompt
        Coords = vector3(-273.894287109375, 685.2567138671875, 113.41388702392578),
        Spawndog = vector4( -284.09, 685.34, 113.59, 234.45 ),
        JobLock = {
            purchasing = false,             -- true or false - Limit purchasing pets to require a job
            selling = false,                -- true or false - Limit selling pets to the NPC to require a job
            jobs = {'doctor', 'vetenarian', 'shepard'}
        },
        Blip = {
            active = true,                  -- true or false
            sprite = "blip_animal",         -- Use Hashname
            scale = 0.5,
            coords = vector3(-273.51, 689.26, 113.41),
        },
        Ped = {
            active = true,                  -- true or false
            modelhash = "am_valentinedoctors_females_01",
            coords = vector4(-273.81170654296875, 684.918701171875, 112.41393280029295, 23.742),
            frozen = true,
            invincible = true,
        }
    }
}

Config.Pets = {
    ['a_c_frogbull_01'] = {
        {
            Text = "Bull Frog",
            SubText = "",
            Desc = "Ribbet Ribbet",
            Param = {
                Price = 30,
                Model = "a_c_frogbull_01",
                Level = 1
            }
        },
    },
    ['a_c_pig_01'] = {
        {
            Text = "Farm Pig",
            SubText = "",
            Desc = "Oink oink",
            Param = {
                Price = 75,
                Model = "a_c_pig_01",
                Level = 1
            }
        }
    },
    ['A_C_DogHusky_01'] = {
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
    },
    ['A_C_DogCatahoulaCur_01'] = {
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
    },
    ['A_C_DogLab_01'] = {
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
    },
    ['A_C_DogRufus_01'] = {
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
    },
    ['A_C_DogBluetickCoonhound_01'] = {
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
    },
    ['A_C_DogHound_01'] = {
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
    },
    ['A_C_DogCollie_01'] = {
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
    },
    ['A_C_DogPoodle_01'] = {
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
    },
    ['A_C_DogAmericanFoxhound_01'] = {
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
    },
    ['A_C_DogAustralianSheperd_01'] = {
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
    },
    ['A_C_Cat_01'] = {
        {
            Text = "Cat",
            SubText = "",
            Desc = "Best pet you'll ever have",
            Param = {
                Price = 100,
                Model = "A_C_Cat_01",
                Level = 1
            }
        },
    },
    ['A_C_Alligator_01'] = {
        {
            Text = "Alligator",
            SubText = "",
            Desc = "Watch your toes!",
            Param = {
                Price = 2750,
                Model = "A_C_Alligator_01",
                Level = 1
            }
        },
    },
    ['a_c_alligator_03'] = {
        {
            Text = "Baby Alligator",
            SubText = "",
            Desc = "Watch your toes!",
            Param = {
                Price = 2650,
                Model = "a_c_alligator_03",
                Level = 1
            }
        },
    },
    ['a_c_sheep_01'] = {
        {
            Text = "Sheep",
            SubText = "",
            Desc = "Baaahhhhh I am here!",
            Param = {
                Price = 150,
                Model = "a_c_sheep_01",
                Level = 1
            }
        },
    }
}
