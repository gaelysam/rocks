-- Load translation library if intllib is installed

local S
if (minetest.get_modpath("intllib")) then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	S = intllib.Getter(minetest.get_current_modname())
	else
	S = function ( s ) return s end
end

local modpath=minetest.get_modpath(minetest.get_current_modname()))

dofile(modpath.."/register.lua")

rocks.noiseparams_layers = {
        offset = 0,
        scale = 1,
        spread = {x=300, y=300, z=300},
        octaves = 3,
        persist = 0.63
}


--
-- test layer
--

rocks.register_layer("test1",{ gain=40, height=70, limit=2, seed=1 },"rocks:black_granite")

-- uhlie ako vrstva je kokotina.

rocks.register_layer("test3",{ gain=40, height=65, limit=2, seed=3 },"rocks:pink_granite")

rocks.register_layer("test4",{ gain=40, height=90, limit=2, seed=4 },"rocks:white_granite")

--
-- test vein
--

rocks.register_vein("testvein1",{
        spread = {x=5, y=90, z=5}, -- tall, narrow
                                   -- larger values -> larger and less frequent vein
        treshold=0.5, -- betveen -2 and +2, mapgen will use this or per-ore treshold if it is larger
                      -- 2 never generate
                      -- 1 extremly rare
                      -- 0 50% chance
                      -- less than 0 = SPAM
        seed = 9, -- random seed
        hmin=65, -- set to nil to generate everywhere
        hmax=90,
        layers={ "test3" }, -- only occur in layers
})
rocks.register_ore( "testvein1", "default:dirt"       , {treshold=0,    chance=1  } )
  -- treshold=0 chance=1 ... generate everywhere
rocks.register_ore( "testvein1", "default:wood"       , {treshold=0,    chance=0.2} )
  -- chance<1 ... vein contains chance*100% of the material, evenly randomly distributed
rocks.register_ore( "testvein1", "default:lava_source", {treshold=0.8,  chance=1  } )
  -- treshold>0 ... generate in the center, larger value -> narrower
 -- 20% wood, lava in center, dirt the rest
 -- ore with smallest chance and highest treshold is selected

dofile(modpath.."/mapgen.lua")

--
--Bedrock
--

minetest.register_node( "rocks:pink_granite", {  
	description = "Pink Granite",
	tiles = { "rocks_pgr.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:pink_granite",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=31, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:black_granite", {  
	description = "Black Granite",
	tiles = { "rocks_blkgr.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:black_granite",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=32, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:white_granite", {  
	description = "White Granite",
	tiles = { "rocks_wgr.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:white_granite",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=33, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:brown_granite", {  
	description = "Brown Granite",
	tiles = { "rocks_brgr.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:brown_granite",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=34, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:red_sandstone", {  
	description = "Red Sandstone",
	tiles = { "rocks_rss.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:red_sandstone",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=35, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:yellow_sandstone", {  
	description = "Yellow Sandstone",
	tiles = { "rocks_yss.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:yellow_sandstone",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=36, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:white_marble", {  
	description = "White Marble",
	tiles = { "rocks_wm.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:white_marble",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=37, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:black_basalt", {  
	description = "Black Basalt",
	tiles = { "rocks_bb.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:black_basalt",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=38, octaves=11, persist=0.0000000001}
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "default:clay",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 6,
		height_min     = -31000,
		height_max     = 15,
		noise_threshhold = 0.5,
		noise_params = {offset=0, scale=15, spread={x=25, y=20, z=30}, seed=15, octaves=3, persist=0.10}
})

print("[rocks] loaded.")
