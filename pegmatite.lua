--
-- Pegmatite vein
--

local CommonRarity=0.02 --too high... should be like 0.013
local CommonRadius=10
local CommonWherein={ "rocks:granite" }

minetest.register_node( "rocks:pegmatite", {
	description = S("Pegmatite"),
	tiles = { "rocks_Pegmatite.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})

-- ores have to be redefined for pegmatite background


