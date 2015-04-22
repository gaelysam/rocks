--
-- Pegmatite deposit
--

local function GetNoiseParams()
 return {
  scale=1, offset=0, seed=rocksl.GetNextSeed(), octaves=1, persist=1,
  spread={ x=100, y=100, z=100 } }
end

-- ores have to be redefined for pegmatite background

--   Ore/Mineral    Percent
-- Spodumene        7%
-- Muscovite (mica) 7%
-- Kyanite          5%
-- Lepidolite       2.5%
-- Tantalite        2%
-- Cassiterite      1.5%
-- Wolframite       1%
-- Pollucite        0.1%


-- Cassiterite
minetest.register_node( "mineral:pegmatite_cassiterite", {
	description = S("Cassiterite"),
	tiles = { "rocks_Pegmatite.png^mineral_cassiterite.png" },
	groups = {cracky=3},
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
 wherein="rocks:pegmatite",
 ore="mineral:pegmatite_cassiterite",
 clust_size=3,
 clust_num_ores=9,
 clust_scarcity=4^3,
 noise_treshold=-0.1,
 noise_params=mineral.noise.Tin
 })

-- ~ Tomas Brod