local CcHard=3
local CcStrong=3
local CcMed=3
local CcSoft=3

--
-- nonvein vein
--

-- Claystone    Sed        soft  in mudstone
rocks.register_vein("clay",{
        spread = {x=30, y=10, z=30},
        treshold=0.2, -- clay should be plenty
        seed = 9,
        layers={ "mudstone" },
})
rocks.register_ore( "clay", "default:clay", {treshold=0, chance=85 } )

-- Breccia      Mixture    soft  in mudstone
-- Conglomerate Sed        soft  in mudstone

-- Limestone    Sed        med   in Rhyolite, Andesite in mountains
minetest.register_node( "rocks:limestone", {  
	description = S("Limestone"),
	tiles = { "rocks_Limestone.png" },
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
	groups = {cracky=CcMed, stone=1}, 
})
rocks.register_vein("limestone",{
        spread = {x=60, y=60, z=60},
        treshold=0.4,
        seed = 10,
        layers={ "rhyolite", "andesite" },
})
rocks.register_ore( "limestone", "rocks:limestone", {treshold=0, chance=100} )
rocks.register_ore( "limestone", "default:torch", {treshold=0, chance=15 } )

-- Dolomite     Sed        med   in Rhyolite, Andesite in mountains
minetest.register_node( "rocks:dolomite", {  
	description = S("Dolomite"),
	tiles = { "rocks_Dolomite.png" },
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
	groups = {cracky=CcMed, stone=1}, 
})
rocks.register_vein("dolomite",{
        spread = {x=60, y=60, z=60},
        treshold=0.4,
        seed = 11,
        layers={ "rhyolite", "andesite" },
})
rocks.register_ore( "dolomite", "rocks:dolomite", {treshold=0, chance=100} )
rocks.register_ore( "dolomite", "default:torch", {treshold=0, chance=15 } )

-- Quartzite    MM/contact vhard sandstone

print("[rocks/geologicaStrata] loaded.")