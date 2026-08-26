-- Kefka's Tower requirement settings are consumable items so they can be
-- adjusted from the tracker UI and saved with tracker state.
local function item_count(code)
    local item = Tracker:FindObjectForCode(code)
    if not item then return 0 end

    if item.AcquiredCount ~= nil then return item.AcquiredCount end
    if item.CurrentStage ~= nil then return item.CurrentStage end
    return 0
end

function canAccessKefkasTower()
    return item_count("Char") >= item_count("requiredchars")
       and item_count("Esper") >= item_count("requiredespers")
end
