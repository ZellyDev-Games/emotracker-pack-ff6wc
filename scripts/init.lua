Tracker:AddItems("items/items.json")
Tracker:AddMaps("maps/maps.json")
Tracker:AddLocations("locations/locations.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")

ScriptHost:LoadScript("scripts/check_counter.lua")
ScriptHost:LoadScript("scripts/logic.lua")
ScriptHost:LoadScript("scripts/autotracking.lua")
