-- AeroGoAC Speed Check 1
-- Modified to allow elytra gliding in Mineclonia

local warned_players = {}

function AeroGoAC_checks.speed_1()
    local speed_limit = tonumber(minetest.settings:get("movement_speed_walk")) or 4.0
    local players = minetest.get_connected_players()

    for _, player in ipairs(players) do
        if not player or not player:is_player() then
            goto continue
        end

        local name = player:get_player_name()

        -- Skip players with fast privilege
        if minetest.check_player_privs(name, {fast = true}) then
            warned_players[name] = nil
            goto continue
        end

        -- Check if player has elytra equipped
        local inv = player:get_inventory()
        local has_elytra = false
        local armor_list = inv and inv:get_list("armor")
        if armor_list then
            for _, stack in ipairs(armor_list) do
                if stack:get_name() == "mcl_elytra:elytra" then
                    has_elytra = true
                    break
                end
            end
        end
        if has_elytra then
            warned_players[name] = nil
            goto continue
        end

        local v = player:get_player_velocity()

        if math.abs(v.x) > speed_limit or math.abs(v.z) > speed_limit then
            if not warned_players[name] then
                minetest.chat_send_player(name, "§eAntiCheat: You have been detected using speed.")
                warned_players[name] = true

                -- Pull player downwards gently
                player:set_velocity({x = v.x, y = -10, z = v.z})

                -- Optional: reset the warning after a while
                minetest.after(30, function()
                    warned_players[name] = nil
                end)
            end
        end

        ::continue::
    end
end
