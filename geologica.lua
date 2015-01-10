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
	tiles = { "rocks_stoneGranite.png" },
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
	groups = {cracky=CcStrong, stone=1}, 
})
rocks.register_layer( "granite",{ gain=20, height=-45, limit=2, seed=1 }, "rocks:granite")

-- Diorite      In/Inter   vhard Below granite                      
minetest.register_node( "rocks:diorite", {  
	description = S("Diorite"),
	tiles = { "rocks_stoneDiorite.png" },
	groups = {cracky=CcHard, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "diorite",{ gain=20, height=-90, limit=2, seed=2 }, "rocks:diorite")

-- Basalt       Ex/Mafic   hard  same as diorite, byt limit=0.5
minetest.register_node( "rocks:basalt", {  
	description = S("Basalt"),
	tiles = { "rocks_stoneBasalt.png" },
	groups = {cracky=CcStrong, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "basalt",{ gain=20, height=-85, limit=-0.7, seed=2 }, "rocks:basalt")

-- Gabbro       In/Mafic   vhard Below basalt/diorite (mtns, ocean) 
minetest.register_node( "rocks:gabbro", {  
	description = S("Gabbro"),
	tiles = { "rocks_stoneGabbro.png" },
	groups = {cracky=CcHard, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "gabbro",{ gain=20, height=-130, limit=2, seed=3 }, "rocks:gabbro")
-- Peridotite   In/UMafic  vhard Rarely under gabbro                
minetest.register_node( "rocks:peridotite", {  
	description = S("Peridotite"),
	tiles = { "rocks_stonePeridotite.png" },
	groups = {cracky=CcStrong, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "peridotite",{ gain=20, height=-200, limit=2, seed=4 }, "rocks:peridotite")
-- Komatiite    Ex/UMafic  -     Too deep                           
-- no texture

--
-- top rocks
--

-- Mudstone     Sed        soft  Ocean, beach, river, glaciers
minetest.register_node( "rocks:mudstone", {  
	description = S("Mudstone"),
	tiles = { "rocks_stoneMudstone.png" },
	groups = {cracky=CcSoft, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
rocks.register_layer( "mudstone",{ gain=6, height=-10, limit=2, seed=4 }, "rocks:mudstone")

-- Slate        MM/barro   med   Under mud/clay/siltstone
-- Schist       MM/barro   med   Under slate, sometimes igneous
-- Gneiss       MM/barro   hard  Under schist, sometimes igneous

-- Hornfels     MM/contact vhard b/w granite and lime/dolo
-- Skarn        MM/contact med   b/w granite and lime/dolo, hornfels
-- Marble       MM/contact hard  b/w granite and lime/dolo          
-- Quartzite    MM/contact vhard sandstone

-- peak rocks
-- Rhyolite     Ex/Felsic  hard  Mountains, top                     
-- Andesite     Ex/Inter   hard  Mountains, below rhyolite          
-- Limestone    Sed        med   Hills                              

-- nonvein vein
-- Claystone    Sed        soft  in mudstone
-- Breccia      Mixture    soft  in mudstone
-- Conglomerate Sed        soft  in mudstone

