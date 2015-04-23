--
-- Igneous Layer
--

-- Basalt       Ex/Mafic   hard  same as diorite, byt limit=0.5
minetest.register_node( "rocks:basalt", {  
	description = S("Basalt"),
	tiles = { "rocks_Basalt.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
minetest.register_alias("mapgen_stone", "rocks:basalt")

-- ^ does not work. Seems we can not overwrite an alias.
-- If the alias in default/mapgen.lua is deleted, this works.

-- more rock defs
minetest.register_node( "rocks:granite", {  
	description = S("Granite"),
	tiles = { "rocks_wgr.png" },
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
	groups = {cracky=3, stone=1}, 
})
minetest.register_node( "rocks:diorite", {  
	description = S("Diorite"),
	tiles = { "rocks_Diorite.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
minetest.register_node( "rocks:gabbro", {  
	description = S("Gabbro"),
	tiles = { "rocks_Gabbro.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})

local reg=function(name,param)
 minetest.register_ore({
   ore    = name,
   wherein= param.inr,
   ore_type       = "scatter",
   clust_scarcity = 10^3,
   clust_num_ores = 20^3,
   clust_size     = 20,
   height_min     = -31000,
   height_max     = 28,
   noise_threshhold=param.treshold,
   noise_params={
          offset = 0, scale = 1, octaves = 1, persist = 0.5,
          spread = {x=param.spread, y=param.height, z=param.spread},
          seed=rocksl.GetNextSeed(),
        },
        })
end
rocks.register_igneous_stratus=reg

-- add our rocks to stone, under -48 there are no biomes, so randomly choose.
 reg( "rocks:basalt", {spread=60, height=40, treshold=0.43, inr={"default:stone"} })

 minetest.register_ore({
  ore="rocks:granite", wherein="default:stone",
  ore_type="scatter", clust_scarcity=3^3, clust_num_ores=6^3, clust_size=6,
  height_min=-31000, height_max=-31,
 })

-- continental (granite): diorite and gabbro
-- oceanic (basalt): gabbro
 reg( "rocks:gabbro",  {spread=80, height=60, treshold=0.36, inr={"rocks:granite","rocks:basalt"} })
 reg( "rocks:diorite", {spread=80, height=60, treshold=0.25, inr={"rocks:granite"} })

-- vein stuff

local regv=function(name,param)
 minetest.register_ore({
   ore    = name,
   wherein= param.wherein,
   ore_type       = "blob",
   clust_scarcity = param.rarity^3,
   clust_num_ores = 8,
   clust_size     = param.radius.average*2,
   height_min     = -31000,
   height_max     = 50,
   noise_threshhold = 0.5, --< determined experimentally
   noise_params={
          offset = 1-param.radius.amplitude, scale = param.radius.amplitude, octaves = 3, persist = 0.5,
          spread = {x=param.radius.frequency, y=param.radius.frequency, z=param.radius.frequency},
          seed=rocksl.GetNextSeed(),
        },
  })
end

rocks.register_vein=regv

rocks.register_vein("default:nyancat",{
  wherein={"rocks:granite", "air"},
  miny=-160, maxy=20,
  radius={ average=10, amplitude=0.1, frequency=8 },
  density=100,
  rarity=70, -- this^3*mapblock_volume veins per mapblock
  ores={
    { ore="default:sand", percent=30 },
    { ore="default:dirt", percent=30 },
  }
  })


-- ~ Tomas Brod