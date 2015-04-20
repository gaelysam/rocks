--
-- Pegmatite vein
--

local CommonRarity=32

minetest.register_node( "rocks:pegmatite", {
	description = S("Pegmatite"),
	tiles = { "rocks_Pegmatite.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})

-- ores have to be redefined for pegmatite background

-- Lepidolite         Li    Medium Pegmatite (2.5%)
-- Cassiterite        Sn    Strong Granite, Pegmatite (1.5%)
-- Pollucite          Cs    Strong Pegmatite (0.1%)
-- Scheelite          W     Medium SEDEX, Pegmatite (2%), Skarn
-- Spodumene          Li    Strong Pegmatite (7%)
-- Tantalite          Ta    Strong Pegmatite (2%)
-- Wolframite         W     Medium Pegmatite (1%)
-- Spodumene        7%
-- Muscovite (mica) 7%
-- Kyanite          5%

-- pegmatites are only 1 kind
rocks.register_vein("rocks:pegmatite",{
  wherein={ "rocks:granite" },
  miny=-160, maxy=20,
  radius={ average=14, amplitude=0.3, frequency=16 },
  density=80, rarity=CommonRarity,
  ores={
  }
 })
