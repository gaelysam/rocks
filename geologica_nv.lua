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
        hmin=-8, hmax=nil,
        layers={ "mudstone" },
})
rocks.register_ore( "clay", "default:clay", {treshold=0, chance=85 } )
rocks.register_ore( "clay", "default:torch", {treshold=0, chance=15 } )

-- Breccia      Mixture    soft  in mudstone
-- Conglomerate Sed        soft  in mudstone
-- Skarn        MM/contact med   in mudstone in mountains
-- Hornfels     MM/contact vhard in mudstone in mountains
-- Marble       MM/contact hard  in mudstone in mountains
-- Limestone    Sed        med   in Rhyolite, Andesite in mountains
rocks.register_vein("limestone",{
        spread = {x=10, y=10, z=10},
        treshold=0.75,
        seed = 10,
        hmin=nil, hmax=nil,
        layers={ "mudstone" },
})
-- Dolomite     Sed        med   in Rhyolite, Andesite in mountains
-- Quartzite    MM/contact vhard sandstone


