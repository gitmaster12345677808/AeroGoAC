-- AeroGoAC Fly Check 1
-- Modified to fully exclude elytra gliding in Mineclonia

local oldpos = {}

-- Check if player has an elytra equipped
local function has_elytra_equipped(player)
    local inv = player:get_inventory()
    local armor_list = inv and inv:get_list("armor")
    if armor_list then
        for _, stack in ipairs(armor_list) do
            if stack:get_name() == "mcl_armor:elytra" and stack:get_count() > 0 then
                return true
            end
        end
    end
    return false
end

-- Fly detection
local function is_flying(player)
    if not player or not player:is_player() then return false end

    local pos = player:get_pos()
    if not pos then return false end
    local name = player:get_player_name()

    -- Skip check if player has fly priv
    if minetest.check_player_privs(name, {fly = true}) then
        return false
    end

    -- Skip check if player has elytra equipped
    if has_elytra_equipped(player) then
        return false
    end

    -- Find nearest solid node up to 3 blocks below
    local ground_y = nil
    for i = 1, 3 do
        local check_pos = {x = pos.x, y = pos.y - i, z = pos.z}
        local node = minetest.get_node(check_pos).name
        if node ~= "air" then
            ground_y = check_pos.y
            break
        end
    end

    if not ground_y then
        ground_y = pos.y - 4
    end

    local height_above_ground = pos.y - ground_y

    -- Flag as flying only if high above ground + moving upward
    if height_above_ground > 3 and player:get_player_velocity().y > 0 then
        return true
    end

    return false
end

-- Main check loop
function AeroGoAC_checks.fly_1()
    local players = minetest.get_connected_players()
    for _, player in ipairs(players) do
        if not player or not player:is_player() then goto continue end
        local name = player:get_player_name()
        local pos = player:get_pos()
        if not pos then goto continue end

        if not is_flying(player) then
            oldpos[name] = pos
        else
            if oldpos[name] then
                player:set_pos(oldpos[name])
                minetest.chat_send_player(name, "§cFlying is not allowed! You have been moved back.")
            else
                player:set_velocity({x=0, y=0, z=0})
                player:set_physics_override({speed=0, jump=0, gravity=1})
                minetest.chat_send_player(name, "§cFlying detected! Please move to the ground.")
            end
        end

        ::continue::
    end
end

