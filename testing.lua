rocks.register_layer("testl", { gain=20, height=-55, limit=2, seed=1 }, "default:wood")

rocks.register_vein("clay",{
        spread = {x=30, y=10, z=30},
        treshold=0.2, -- clay should be plenty
        seed = 9,
        hmin=-8, hmax=nil,
        layers={ "mudstone" },
})

rocks.register_ore( "clay", "default:clay", {treshold=0, chance=85 } )
rocks.register_ore( "clay", "default:torch", {treshold=0, chance=15 } )
