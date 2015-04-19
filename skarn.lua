--
-- Skarn deposit
--

local CommonRarity=40 --too high... should be like 76
local CommonRadius=10
local CommonWherein={ "rocks:granite", "rocks:limestone" }

minetest.register_node( "rocks:skarn", {  
	description = S("Skarn"),
	tiles = { "rocks_Skarn.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})

-- skarn deposit
rocks.register_vein("rocks:skarn",{
  wherein=CommonWherein,
  miny=-320, maxy=300,
  radius={ average=CommonRadius, amplitude=0.16, frequency=8 },
  density=80, rarity=CommonRarity,
 })

local function GetNoiseParams()
 return {
  scale=1, offset=0, seed=rocksl.GetNextSeed(), octaves=1, persist=1,
  spread={ x=100, y=100, z=100 } }
end

-- ores have to be redefined for skarn background

   -- Todo:
   -- There is also a chance of isolated lapis crystals, Gold
   -- Molybdenite with Cu
   -- wollastonite with Fe
   -- enrichments: scheelite and wollastonite

-- Chalcopyrite
minetest.register_node( "rocks:skarn_chalcopyrite", {  
	description = S("Chalcopyrite"),
	tiles = { "rocks_Skarn.png^rocks_Chalcopyrite.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Malachyte
minetest.register_node( "rocks:skarn_malachyte", {  
	description = S("Malachyte"),
	tiles = { "rocks_Skarn.png^rocks_Chalcopyrite.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Chalcopyrite/Malachyte skarn mix
rocksl.CopperNoise=GetNoiseParams()
minetest.register_ore({
 wherein="rocks:skarn",
 ore="rocks:skarn_chalcopyrite",
 clust_size=3,
 clust_num_ores=12,
 clust_scarcity=4^3,
 noise_treshold=0.333,
 noise_params=rocksl.CopperNoise
 })
minetest.register_ore({
 wherein="rocks:skarn",
 ore="rocks:skarn_malachyte",
 clust_size=3,
 clust_num_ores=11,
 clust_scarcity=4^3,
 noise_treshold=0.333,
 noise_params=rocksl.CopperNoise
 })

-- Sphalerite
minetest.register_node( "rocks:skarn_sphalerite", {  
	description = S("Sphalerite"),
	tiles = { "rocks_Skarn.png^rocks_sphalerite.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Galena
minetest.register_node( "rocks:skarn_galena", {  
	description = S("Galena"),
	tiles = { "rocks_Skarn.png^rocks_galena.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Pb Zn skarn mix
rocksl.PbZnNoise=GetNoiseParams()
minetest.register_ore({
 wherein="rocks:skarn",
 ore="rocks:skarn_sphalerite",
 clust_size=3,
 clust_num_ores=9,
 clust_scarcity=4^3,
 noise_treshold=0.38,
 noise_params=rocksl.PbZnNoise
 })
minetest.register_ore({
 wherein="rocks:skarn",
 ore="rocks:skarn_galena",
 clust_size=3,
 clust_num_ores=10,
 clust_scarcity=4^3,
 noise_treshold=0.38,
 noise_params=rocksl.PbZnNoise
 })
   -- marble and hornfels, as well as unchanged limestone.
   -- { ore="rocks:marble", percent=10 },
   -- { ore="rocks:hornfels", percent=10 },
   -- { ore="rocks:skarn_galena", percent=25 },
   -- { ore="rocks:skarn_sphalerite", percent=25 },

-- Magnetite
minetest.register_node( "rocks:skarn_magnetite", {  
	description = S("Magnetite"),
	tiles = { "rocks_Skarn.png^rocks_Magnetite.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Fe skarn mix
rocksl.IronNoise=GetNoiseParams()
minetest.register_ore({
 wherein="rocks:skarn",
 ore="rocks:skarn_magnetite",
 clust_size=3,
 clust_num_ores=13,
 clust_scarcity=4^3,
 noise_treshold=0.3,
 noise_params=rocksl.IronNoise
 })
   -- marble and hornfels, as well as unchanged limestone.
   -- { ore="rocks:marble", percent=10 },
   -- { ore="rocks:hornfels", percent=10 },
   -- { ore="rocks:skarn_magnetite", percent=40 },

-- Magnesite
minetest.register_node( "rocks:skarn_magnesite", {
	description = S("Magnesite"),
	tiles = { "rocks_Skarn.png^rocks_Magnesite.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Vermiculite (fixme: move to CommonRocks)
minetest.register_node( "rocks:vermiculite", {
	description = S("Vermiculite"),
	tiles = { "rocks_Vermiculite.png" },
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