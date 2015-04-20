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

   -- Todo:
   -- There is also a chance of isolated lapis crystals, Gold
   -- Molybdenite with Cu
   -- wollastonite with Fe
   -- enrichments: scheelite and wollastonite

-- ~ Tomas Brod