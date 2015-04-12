--
-- Skarn deposit
--

local CommonRarity=0.02 --too high... should be like 0.013
local CommonRadius=10
local CommonWherein={ "rocks:granite" }

minetest.register_node( "rocks:skarn", {  
	description = S("Skarn"),
	tiles = { "rocks_Skarn.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})

-- ores have to be redefined for skarn background

   -- There is also a chance of isolated lapis crystals
   -- enrichments: scheelite and wollastonite  -> in each vein

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
rocks.register_vein("rocks:skarn",{
  wherein=CommonWherein,
  miny=-160, maxy=20,
  radius={ average=CommonRadius, amplitude=3, frequency=5 },
  density=80, rarity=CommonRarity,
  ores={
   -- marble and hornfels, as well as unchanged limestone.
   -- { ore="rocks:marble", percent=10 },
   -- { ore="rocks:hornfels", percent=10 },
    { ore="rocks:skarn_chalcopyrite", percent=30 },
    { ore="rocks:skarn_malachyte", percent=15 },
  }
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
rocks.register_vein("rocks:skarn",{
  wherein=CommonWherein,
  miny=-160, maxy=20,
  radius={ average=CommonRadius, amplitude=3, frequency=5 },
  density=80, rarity=CommonRarity,
  ores={
   -- marble and hornfels, as well as unchanged limestone.
   -- { ore="rocks:marble", percent=10 },
   -- { ore="rocks:hornfels", percent=10 },
    { ore="rocks:skarn_galena", percent=25 },
    { ore="rocks:skarn_sphalerite", percent=25 },
  }
 })

-- Magnetite
minetest.register_node( "rocks:skarn_magnetite", {  
	description = S("Magnetite"),
	tiles = { "rocks_Skarn.png^rocks_Magnetite.png" },
	groups = {cracky=3}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
-- Fe skarn mix
rocks.register_vein("rocks:skarn",{
  wherein=CommonWherein,
  miny=-160, maxy=20,
  radius={ average=CommonRadius, amplitude=3, frequency=5 },
  density=80, rarity=CommonRarity,
  ores={
   -- marble and hornfels, as well as unchanged limestone.
   -- { ore="rocks:marble", percent=10 },
   -- { ore="rocks:hornfels", percent=10 },
    { ore="rocks:skarn_magnetite", percent=40 },
  }
 })

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
rocks.register_vein("rocks:skarn",{
  wherein=CommonWherein,
  miny=-160, maxy=20,
  radius={ average=CommonRadius, amplitude=3, frequency=5 },
  density=80, rarity=CommonRarity,
  ores={
   -- marble and hornfels, as well as unchanged limestone.
   -- { ore="rocks:marble", percent=10 },
   -- { ore="rocks:hornfels", percent=10 },
    { ore="rocks:skarn_magnesite", percent=30 },
    { ore="rocks:vermiculite", percent=20 },
  }
 })

-- ~ Tomas Brod