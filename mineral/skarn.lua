--
-- Skarn deposit
--

local function GetNoiseParams()
 return {
  scale=1, offset=0, seed=rocksl.GetNextSeed(), octaves=1, persist=1,
  spread={ x=100, y=100, z=100 } }
end

-- ores have to be redefined for skarn background

-- Chalcopyrite
minetest.register_node( "mineral:skarn_chalcopyrite", {  
	description = S("Chalcopyrite"),
	tiles = { "rocks_Skarn.png^mineral_Chalcopyrite.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Malachyte
minetest.register_node( "mineral:skarn_malachyte", {  
	description = S("Malachyte"),
	tiles = { "rocks_Skarn.png^mineral_Chalcopyrite.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Chalcopyrite/Malachyte skarn mix
mineral.noise.Copper=GetNoiseParams()
minetest.register_ore({
 wherein="rocks:skarn",
 ore="mineral:skarn_chalcopyrite",
 clust_size=3,
 clust_num_ores=12,
 clust_scarcity=4^3,
 noise_treshold=0.333,
 noise_params=mineral.noise.Copper
 })
minetest.register_ore({
 wherein="rocks:skarn",
 ore="mineral:skarn_malachyte",
 clust_size=3,
 clust_num_ores=11,
 clust_scarcity=4^3,
 noise_treshold=0.333,
 noise_params=mineral.noise.Copper
 })

-- Sphalerite
minetest.register_node( "mineral:skarn_sphalerite", {  
	description = S("Sphalerite"),
	tiles = { "rocks_Skarn.png^mineral_sphalerite.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Galena
minetest.register_node( "mineral:skarn_galena", {  
	description = S("Galena"),
	tiles = { "rocks_Skarn.png^mineral_galena.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Pb Zn skarn mix
mineral.noise.PbZn=GetNoiseParams()
minetest.register_ore({
 wherein="rocks:skarn",
 ore="mineral:skarn_sphalerite",
 clust_size=3,
 clust_num_ores=9,
 clust_scarcity=4^3,
 noise_treshold=0.38,
 noise_params=mineral.noise.PbZn
 })
minetest.register_ore({
 wherein="rocks:skarn",
 ore="mineral:skarn_galena",
 clust_size=3,
 clust_num_ores=10,
 clust_scarcity=4^3,
 noise_treshold=0.38,
 noise_params=mineral.noise.PbZn
 })
   -- marble and hornfels, as well as unchanged limestone.
   -- { ore="rocks:marble", percent=10 },
   -- { ore="rocks:hornfels", percent=10 },
   -- { ore="rocks:skarn_galena", percent=25 },
   -- { ore="rocks:skarn_sphalerite", percent=25 },

-- Magnetite
minetest.register_node( "mineral:skarn_magnetite", {  
	description = S("Magnetite"),
	tiles = { "rocks_Skarn.png^mineral_Magnetite.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Fe skarn mix
mineral.noise.Iron=GetNoiseParams()
minetest.register_ore({
 wherein="rocks:skarn",
 ore="mineral:skarn_magnetite",
 clust_size=3,
 clust_num_ores=13,
 clust_scarcity=4^3,
 noise_treshold=0.3,
 noise_params=mineral.noise.Iron
 })
   -- marble and hornfels, as well as unchanged limestone.
   -- { ore="rocks:marble", percent=10 },
   -- { ore="rocks:hornfels", percent=10 },
   -- { ore="rocks:skarn_magnetite", percent=40 },

-- Magnesite
minetest.register_node( "mineral:skarn_magnesite", {
	description = S("Magnesite"),
	tiles = { "rocks_Skarn.png^mineral_Magnesite.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Vermiculite (fixme: move to CommonRocks)
minetest.register_node( "mineral:vermiculite", {
	description = S("Vermiculite"),
	tiles = { "mineral_Vermiculite.png" },
	groups = {crumbly=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- magnesite/vermiculite skarn mix
   -- marble and hornfels, as well as unchanged limestone.
   -- { ore="rocks:marble", percent=10 },
   -- { ore="rocks:hornfels", percent=10 },
   -- { ore="rocks:skarn_magnesite", percent=30 },
   -- { ore="rocks:vermiculite", percent=20 },

-- ~ Tomas Brod