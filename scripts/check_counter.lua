local CHECK_TOGGLES = {
    "Whelk", "LoneWolf", "MogDef", "FigThrone", "Vargas", "ImperialCamp",
    "NarsheWpn", "WoBDoma", "Owzer", "ChainedCeles", "ZozoRamuh",
    "DoomGaze", "DarillTomb", "WoBThamasa", "GauManor", "VeldtJerky",
    "PhantomTrain", "EsperMtn", "KohlingenDoge", "FanaticsTower",
    "Phunbaba", "AncientCastle", "MtZozo", "WoRVeldt", "FigCave",
    "Tritoch", "tunnelArmor", "TzenHouse", "SerpentTrench", "TzenThief",
    "LeteRiver", "Umaro", "OperaHouse", "ZoneEater", "BarenFalls",
    "EbotsRock", "PhoenixCave", "AtmaWpn", "FinalKefka", "NarsheKefka"
}

local CHECK_PROGRESSIVES = {
    { "Magitek", 0, 3 }, { "Auctioneer", 0, 0 }, { "Float", 0, 3 },
    { "WoRDoma", 0, 3 }, { "Dragon", 0, 8 }
}

local CHARACTER_CODES = {
    "Terra", "Locke", "Cyan", "Shadow", "Edgar", "Sabin", "Celes",
    "Strago", "Relm", "Setzer", "Mog", "Gau", "Gogo", "UmaroCharacter"
}

local DRAGON_CODES = {
    "IceDragon", "StormDragon", "DirtDragon", "GoldDragon",
    "SkullDragon", "BlueDragon", "RedDragon", "WhiteDragon"
}

local MAGITEK_CODES = { "IfritandShiva", "Number024", "Cranes" }
local AUCTION_CODES = { "AuctionHouse10kGP", "AuctionHouse20kGP" }
local FLOAT_CODES = { "ImperialAirForce", "AtmaWeapon", "Nerapa" }
local DOMA_CODES = { "DreamStooges", "Wrexsoul", "DomaCastleThrone" }

local updating_check_counter = false

local function update_character_counter()
    local acquired = 0
    for _, code in ipairs(CHARACTER_CODES) do
        local character = Tracker:FindObjectForCode(code)
        if character and character.Active then acquired = acquired + 1 end
    end

    local counter = Tracker:FindObjectForCode("Char")
    if counter then
        counter.CurrentStage = acquired
    end
end

local function update_dragon_counter()
    local defeated = 0
    for _, code in ipairs(DRAGON_CODES) do
        local dragon = Tracker:FindObjectForCode(code)
        if dragon and dragon.Active then defeated = defeated + 1 end
    end

    local counter = Tracker:FindObjectForCode("Dragon")
    if counter then counter.CurrentStage = defeated end
end

local function update_magitek_counter()
    local completed = 0
    for _, code in ipairs(MAGITEK_CODES) do
        local check = Tracker:FindObjectForCode(code)
        if check and check.Active then completed = completed + 1 end
    end

    local counter = Tracker:FindObjectForCode("Magitek")
    if counter then counter.CurrentStage = completed end
end

function update_auction_counter()
    local completed_slots = 0
    for _, code in ipairs(AUCTION_CODES) do
        local check = Tracker:FindObjectForCode(code)
        if check and check.Active then completed_slots = completed_slots + 1 end
    end

    local configured = Tracker:FindObjectForCode("requiredauctionchecks")
    local required = configured and configured.AcquiredCount or 1
    local completed = math.min(completed_slots, required)

    local map_check = Tracker:FindObjectForCode("AuctionComplete")
    if map_check then map_check.Active = completed_slots >= required end

    local counter = Tracker:FindObjectForCode("Auctioneer")
    if counter then counter.CurrentStage = completed end
end

local function apply_auction_manual_clear()
    local map_check = Tracker:FindObjectForCode("AuctionComplete")
    local counter = Tracker:FindObjectForCode("Auctioneer")
    if not map_check or not counter then return end
    if map_check.Active or counter.CurrentStage == 0 then return end

    counter.CurrentStage = 0
    for _, code in ipairs(AUCTION_CODES) do
        local check = Tracker:FindObjectForCode(code)
        if check then check.Active = false end
    end
end

local function update_progressive_from_toggles(counter_code, check_codes)
    local completed = 0
    for _, code in ipairs(check_codes) do
        local check = Tracker:FindObjectForCode(code)
        if check and check.Active then completed = completed + 1 end
    end

    local counter = Tracker:FindObjectForCode(counter_code)
    if counter then counter.CurrentStage = completed end
end

function update_floating_counter()
    update_progressive_from_toggles("Float", FLOAT_CODES)
end

function update_doma_counter()
    update_progressive_from_toggles("WoRDoma", DOMA_CODES)
end

function update_check_counter()
    if updating_check_counter then return end
    updating_check_counter = true

    local completed = 0
    for _, code in ipairs(CHECK_TOGGLES) do
        local item = Tracker:FindObjectForCode(code)
        if item and item.Active then
            completed = completed + 1
        end
    end

    for _, progressive in ipairs(CHECK_PROGRESSIVES) do
        local item = Tracker:FindObjectForCode(progressive[1])
        if item then
            completed = completed + item.CurrentStage + progressive[2]
        end
    end

    local configured = Tracker:FindObjectForCode("requiredauctionchecks")
    local required_auction_checks = configured and configured.AcquiredCount or 1
    local total = #CHECK_TOGGLES + required_auction_checks
    for _, progressive in ipairs(CHECK_PROGRESSIVES) do
        total = total + progressive[3]
    end

    local counter = Tracker:FindObjectForCode("CheckCounter")
    if counter then
        counter.AcquiredCount = completed
        -- Consumable items normally suppress their badge at zero. This is a
        -- status display, so keep the current value visible even when it is 0.
        counter.BadgeText = tostring(completed) .. "/" .. tostring(total)
    end

    updating_check_counter = false
end

-- Item state changes cause an accessibility refresh. Recalculate here so
-- manual clicks and auto-tracked changes both update the displayed count.
function tracker_on_accessibility_updated()
    apply_auction_manual_clear()
    update_character_counter()
    update_dragon_counter()
    update_magitek_counter()
    update_auction_counter()
    update_floating_counter()
    update_doma_counter()
    update_check_counter()
end

function tracker_on_pack_ready()
    update_character_counter()
    update_dragon_counter()
    update_magitek_counter()
    update_auction_counter()
    update_floating_counter()
    update_doma_counter()
    update_check_counter()
end
