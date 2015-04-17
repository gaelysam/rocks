--
-- Sedimentary Layer
--

-- Mudstone     Sed        soft  Ocean, beach, river, glaciers
minetest.register_node( "rocks:mudstone", {  
	description = S("Mudstone"),
	tiles = { "rocks_Mudstone.png" },
	groups = {cracky=1, crumbly=3}, 
	is_ground_content = true, sounds = default.node_sound_dirt_defaults(),
})

do -- Modify default grassland biome
 local grassland=minetest.registered_biomes["default:grassland"] or
  {
   name = "rocks:grassland",
   node_top = "default:dirt_with_grass",
   depth_top = 1,
   y_min = 5,
   y_max = 31000,
   heat_point = 50,
   humidity_point = 50,
  }
 grassland.node_filler="rocks:mudstone"
 grassland.depth_filler=11
 minetest.clear_registered_biomes()
 minetest.register_biome(grassland)
end

-- more biomes


-- more rock defs
minetest.register_node( "rocks:limestone", {  
	description = S("Limestone"),
	tiles = { "rocks_Limestone.png" },
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
	groups = {cracky=2},
})


local reg=function(name,param)
 minetest.register_ore({
  ore=name,
  wherein= { 
         "rocks:mudstone",
         },
  ore_type         = "scatter",
  clust_scarcity   = 1,
  clust_size       = 3,
  clust_num_ores   = 27,
  y_min            = -20,
  y_max            = 40,
  noise_threshhold = param.treshold,
  noise_params     = {
          offset=0, scale=1, octaves=3, persist=0.3,
          spread={x=param.spread, y=param.height, z=param.spread},
          seed=rocksl.GetNextSeed(),
                     },
 })
end

rocks.register_sedimentary=reg

--               Sedimentary rock hardness and distribution
--    Rock      Hard                      Distribution
--Breccia      Weak   Localized continental, folded
-->Claystone    Weak   Localized continental, folded, oceanic
--Conglomerate Weak   Localized continental, folded
-->Limestone    Medium Localized continental, folded; primary oceanic, hills
-->Coal         -      Large beds, twice as common in swamps
 --reg("rocks:limestone",    { spread=64, height=32, treshold=0.35 })
 --reg("rocks:breccia",  { spread=64, height=32, treshold=0.6 })
 --reg("rocks:conglomerate", { spread=64, height=32, treshold=0.6 })
 reg("default:stone_with_coal", { spread=64, height=14, treshold=0.60 })
 reg("default:clay",{ spread=48, height=14, treshold=0.56 })

-- ~ Tomas Brod