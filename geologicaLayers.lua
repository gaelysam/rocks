local CcHard=3
local CcStrong=3
local CcMed=3
local CcSoft=3

--
-- Main rocks (top to bottom)
--

-- Granite      In/Felsic  hard  Very common, below sed on land     
minetest.register_node( "rocks:granite", {  
	description = S("Granite"),
	tiles = { "rocks_Granite.png" },
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
	groups = {cracky=CcStrong, stone=1}, 
})
rocks.register_layer( "granite",{ gain=20, height=-55, limit=2, seed=1 }, "rocks:granite")

-- Diorite      In/Inter   vhard Below granite                      
minetest.register_node( "rocks:diorite", {  
	description = S("Diorite"),
	tiles = { "rocks_Diorite.png" },
	groups = {cracky=CcHard, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "diorite",{ gain=20, height=-80, limit=2, seed=2 }, "rocks:diorite")

-- Basalt       Ex/Mafic   hard  same as diorite, byt limit=0.5
minetest.register_node( "rocks:basalt", {  
	description = S("Basalt"),
	tiles = { "rocks_Basalt.png" },
	groups = {cracky=CcStrong, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "basalt",{ gain=20, height=-75, limit=-0.7, seed=2 }, "rocks:basalt")

-- Gabbro       In/Mafic   vhard Below basalt/diorite (mtns, ocean) 
minetest.register_node( "rocks:gabbro", {  
	description = S("Gabbro"),
	tiles = { "rocks_Gabbro.png" },
	groups = {cracky=CcHard, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "gabbro",{ gain=20, height=-120, limit=2, seed=3 }, "rocks:gabbro")

-- Peridotite   In/UMafic  vhard Rarely under gabbro                
minetest.register_node( "rocks:peridotite", {  
	description = S("Peridotite"),
	tiles = { "rocks_Peridotite.png" },
	groups = {cracky=CcStrong, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "peridotite",{ gain=20, height=-130, limit=-0.8, seed=4 }, "rocks:peridotite")

-- Komatiite    Ex/UMafic  -     Too deep                           
minetest.register_node( "rocks:komatiite", {  
	description = S("Komatiite"),
	tiles = { "default_stone.png" },  -- no texture, yet
	groups = {cracky=CcHard, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "komatiite",{ gain=20, height=-200, limit=2, seed=5 }, "rocks:komatiite")

--
-- top sedimentary rocks
--

-- Mudstone     Sed        soft  Ocean, beach, river, glaciers
minetest.register_node( "rocks:mudstone", {  
	description = S("Mudstone"),
	tiles = { "rocks_Mudstone.png" },
	groups = {cracky=CcSoft, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "mudstone",{ gain=10, height=-13, limit=2, seed=4 }, "rocks:mudstone")

-- Slate        MM/barro   med   Under mud/clay/siltstone
minetest.register_node( "rocks:slate", {  
	description = S("slate"),
	tiles = { "rocks_Slate.png" },
	groups = {cracky=CcMed, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "slate",{ gain=10, height=-15, limit=2, seed=5 }, "rocks:slate")

-- Schist       MM/barro   med   Under slate, sometimes igneous
minetest.register_node( "rocks:schist", {  
	description = S("schist"),
	tiles = { "rocks_Schist.png" },
	groups = {cracky=CcMed, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "schist",{ gain=10, height=-18, limit=2, seed=5 }, "rocks:schist")

-- Gneiss       MM/barro   hard  Under schist, sometimes igneous
minetest.register_node( "rocks:gneiss", {  
	description = S("gneiss"),
	tiles = { "rocks_Gneiss.png" },
	groups = {cracky=CcStrong, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "gneiss",{ gain=10, height=-21, limit=2, seed=6 }, "rocks:gneiss")

--
-- peak rocks
--

-- Rhyolite     Ex/Felsic  hard  Mountains, top                     
minetest.register_node( "rocks:rhyolite", {  
	description = S("Rhyolite"),
	tiles = { "rocks_Rhyolite.png" },
	groups = {cracky=CcHard, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "rhyolite",{ gain=8, height=22, limit=2, seed=4 }, "rocks:rhyolite")

-- Andesite     Ex/Inter   hard  Mountains, below rhyolite          
minetest.register_node( "rocks:andesite", {  
	description = S("Andesite"),
	tiles = { "rocks_Andesite.png" },
	groups = {cracky=CcHard, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "andesite",{ gain=8, height=10, limit=2, seed=4 }, "rocks:andesite")

print("[rocks/geologicaLayers] loaded.")
