local function bit_is_set(segment, address, mask)
    return (segment:ReadUInt8(address) & mask) ~= 0
end

local function set_toggle(segment, code, address, mask)
    local item = Tracker:FindObjectForCode(code)
    if item then
        item.Active = bit_is_set(segment, address, mask)
    end
end

local function bit_count(value)
    local count = 0
    for bit = 0, 7 do
        if (value & (1 << bit)) ~= 0 then count = count + 1 end
    end
    return count
end

local function set_stage(code, stage)
    local item = Tracker:FindObjectForCode(code)
    if item then item.CurrentStage = stage end
end

local function set_active(code, active)
    local item = Tracker:FindObjectForCode(code)
    if item then item.Active = active end
end

-- Final Kefka does not leave behind a convenient persistent event flag. The
-- OpenSplit Ultros League provider recognizes the kill from this short-lived
-- battle signature, so remember the latest values from two fast watches and
-- latch the check once both occur together.
local kefka_battle_index = nil
local kefka_sound_effect = nil

local function detect_final_kefka()
    if kefka_battle_index ~= 514 or kefka_sound_effect ~= 227 then return end

    local kefka = Tracker:FindObjectForCode("FinalKefka")
    if kefka and not kefka.Active then kefka.Active = true end
end

local function update_kefka_battle(segment)
    kefka_battle_index = segment:ReadUInt16(0x7E11E0)
    return true
end

local function update_kefka_sound(segment)
    kefka_sound_effect = segment:ReadUInt8(0x7EE9E9)
    detect_final_kefka()
    return true
end

local function update_party(segment)
    local first = segment:ReadUInt8(0x7E1EDE)
    local second = segment:ReadUInt8(0x7E1EDF) & 0x3F

    set_active("Terra",          (first & 0x01) ~= 0)
    set_active("Locke",          (first & 0x02) ~= 0)
    set_active("Cyan",           (first & 0x04) ~= 0)
    set_active("Shadow",         (first & 0x08) ~= 0)
    set_active("Edgar",          (first & 0x10) ~= 0)
    set_active("Sabin",          (first & 0x20) ~= 0)
    set_active("Celes",          (first & 0x40) ~= 0)
    set_active("Strago",         (first & 0x80) ~= 0)
    set_active("Relm",          (second & 0x01) ~= 0)
    set_active("Setzer",        (second & 0x02) ~= 0)
    set_active("Mog",           (second & 0x04) ~= 0)
    set_active("Gau",           (second & 0x08) ~= 0)
    set_active("Gogo",          (second & 0x10) ~= 0)
    set_active("UmaroCharacter", (second & 0x20) ~= 0)

    set_stage("Char", bit_count(first) + bit_count(second))
    update_check_counter()
    return true
end

local EVENT_FLAGS = {
    { "Whelk",          0x7E1EA6, 0x20 },
    { "LoneWolf",       0x7E1EC7, 0x80 },
    { "MogDef",         0x7E1EA5, 0x40 },
    { "FigThrone",      0x7E1E80, 0x10 },
    { "Vargas",         0x7E1E82, 0x01 },
    { "ImperialCamp",   0x7E1E86, 0x80 },
    { "NarsheWpn",      0x7E1E96, 0x40 },
    { "PhoenixCave",    0x7E1E9A, 0x80 },
    { "WoBDoma",        0x7E1E88, 0x01 },
    { "NarsheKefka",    0x7E1E88, 0x40 },
    { "Owzer",          0x7E1ECA, 0x08 },
    { "ChainedCeles",   0x7E1E83, 0x20 },
    { "IfritandShiva",  0x7E1E8C, 0x02 },
    { "Number024",      0x7E1E8B, 0x80 },
    { "Cranes",         0x7E1E8D, 0x08 },
    { "ImperialAirForce", 0x7E1E85, 0x04 },
    { "AtmaWeapon",       0x7E1E94, 0x02 },
    { "Nerapa",           0x7E1E94, 0x20 },
    { "DreamStooges",     0x7E1E9B, 0x01 },
    { "Wrexsoul",         0x7E1E9B, 0x04 },
    { "DomaCastleThrone", 0x7E1E9B, 0x08 },
    { "ZozoRamuh",      0x7E1E8A, 0x04 },
    { "DoomGaze",       0x7E1ED4, 0x02 },
    { "DarillTomb",     0x7E1ED6, 0x04 },
    { "WoBThamasa",     0x7E1E92, 0x01 },
    { "GauManor",       0x7E1EAC, 0x04 },
    { "VeldtJerky",     0x7E1EB7, 0x10 },
    { "PhantomTrain",   0x7E1EB2, 0x04 },
    { "EsperMtn",       0x7E1E92, 0x20 },
    { "KohlingenDoge",  0x7E1EB1, 0x40 },
    { "FanaticsTower",  0x7E1E97, 0x04 },
    { "Phunbaba",       0x7E1E97, 0x80 },
    { "AncientCastle",  0x7E1EDB, 0x20 },
    { "MtZozo",         0x7E1E9A, 0x04 },
    { "WoRVeldt",       0x7E1EB3, 0x02 },
    { "FigCave",        0x7E1E98, 0x40 },
    { "Tritoch",        0x7E1ED3, 0x40 },
    { "tunnelArmor",    0x7E1E96, 0x02 },
    { "TzenHouse",      0x7E1ED1, 0x04 },
    { "SerpentTrench",  0x7E1E8A, 0x01 },
    { "TzenThief",      0x7E1ECF, 0x10 },
    { "LeteRiver",      0x7E1ECA, 0x80 },
    { "Umaro",          0x7E1E8F, 0x40 },
    { "OperaHouse",     0x7E1E8B, 0x08 },
    { "ZoneEater",      0x7E1E9A, 0x10 },
    { "BarenFalls",     0x7E1E87, 0x80 },
    { "EbotsRock",      0x7E1EB3, 0x10 },
    { "AtmaWpn",        0x7E1E94, 0x04 },
    { "IceDragon",      0x7E1EA3, 0x04 },
    { "StormDragon",    0x7E1EA3, 0x08 },
    { "DirtDragon",     0x7E1EA3, 0x10 },
    { "GoldDragon",     0x7E1EA3, 0x20 },
    { "SkullDragon",    0x7E1EA3, 0x40 },
    { "BlueDragon",     0x7E1EA3, 0x80 },
    { "RedDragon",      0x7E1EA4, 0x01 },
    { "WhiteDragon",    0x7E1EA4, 0x02 }
}

local function update_events(segment)
    for _, flag in ipairs(EVENT_FLAGS) do
        set_toggle(segment, flag[1], flag[2], flag[3])
    end

    local auction = segment:ReadUInt8(0x7E1EAD)
    set_active("AuctionHouse10kGP", (auction & 0x20) ~= 0)
    set_active("AuctionHouse20kGP", (auction & 0x10) ~= 0)
    update_auction_counter()

    local magitek = 0
    if bit_is_set(segment, 0x7E1E8C, 0x02) then magitek = magitek + 1 end
    if bit_is_set(segment, 0x7E1E8B, 0x80) then magitek = magitek + 1 end
    if bit_is_set(segment, 0x7E1E8D, 0x08) then magitek = magitek + 1 end
    set_stage("Magitek", magitek)

    update_floating_counter()
    update_doma_counter()

    update_check_counter()
    return true
end

local function update_counters(segment)
    set_stage("Esper", segment:ReadUInt8(0x7E1FC8))
    set_stage("Dragon", segment:ReadUInt8(0x7E1FCE))
    update_check_counter()
    return true
end

local function update_treasure(segment)
    local opened = 0
    for offset = 0, 0x2F do
        opened = opened + bit_count(segment:ReadUInt8(0x7E1E40 + offset))
    end

    local counter = Tracker:FindObjectForCode("Treasure")
    if counter then counter.AcquiredCount = opened end
    return true
end

ScriptHost:AddMemoryWatch("FF6WC Party", 0x7E1EDE, 0x02, update_party, 250)
ScriptHost:AddMemoryWatch("FF6WC Events", 0x7E1E80, 0xDF, update_events, 250)
ScriptHost:AddMemoryWatch("FF6WC Counters", 0x7E1FC2, 0x0D, update_counters, 250)
ScriptHost:AddMemoryWatch("FF6WC Treasure", 0x7E1E40, 0x30, update_treasure, 250)
ScriptHost:AddMemoryWatch("FF6WC Final Kefka Battle", 0x7E11E0, 0x02, update_kefka_battle, 20)
ScriptHost:AddMemoryWatch("FF6WC Final Kefka SFX", 0x7EE9E9, 0x01, update_kefka_sound, 20)
