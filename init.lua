-- AeroGoAC Anticheat Mod
local version = "1.1.0"
local modpath = minetest.get_modpath("aerogo")

if not modpath then
    error("AeroGoAC modpath not found. Ensure the mod folder is named 'aerogo' and is in the correct mods directory.")
end

AeroGoAC_checks = {}

local modules = {
    "autohandle",
    "checks/speed-1",
    "checks/fly-1",
    "checks/fly-2",
    "checks/client_init/antifastbreak",
}

for _, module in pairs(modules) do
    local success, err = pcall(function()
        dofile(modpath .. "/" .. module .. ".lua")
    end)
    if not success then
        minetest.log("error", "[AeroGoAC] Failed to load module " .. module .. ": " .. tostring(err))
    else
        minetest.log("info", "[AeroGoAC] Successfully loaded module " .. module)
    end
end

minetest.register_chatcommand("aero", {
    description = "Returns the current Version of the installed Aratox anticheat.",
    params = "",
    privs = {shout = true},
    func = function(playername, param)
        minetest.chat_send_player(playername, "AeroGoAC Anticheat v" .. version .. " (~Zander, contentdb: @zanderdev)")
    end,
})

minetest.register_globalstep(function(dtime)
    if AeroGoAC_checks.fly_1 then
        AeroGoAC_checks.fly_1()
    else
        minetest.log("error", "[AeroGoAC] fly_1 function not found")
    end
    if AeroGoAC_checks.fly_2 then
        AeroGoAC_checks.fly_2()
    else
        minetest.log("error", "[AeroGoAC] fly_2 function not found")
    end
    if AeroGoAC_checks.speed_1 then
        AeroGoAC_checks.speed_1()
    else
        minetest.log("error", "[AeroGoAC] speed_1 function not found")
    end
end)
