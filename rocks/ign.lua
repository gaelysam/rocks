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

local np_layer = {
 offset = 0, octaves = 3, persist = 0.46,
 scale = 30,
 spread = {x=500, y=500, z=500},
 seed = -5500,
}
local np_intr = {
 octaves = 3, persist = 0.46,
 scale = 20,
 offset = -15,
 spread = {x=100, y=100, z=100},
 seed = 3740,
}

minetest.register_on_generated( function( minp, maxp, seed )
 local t1 = os.clock()
 local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
 local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
 local data = vm:get_data()

 local chunksize = maxp.x - minp.x + 1
 local pmapsize = {x = chunksize, y = chunksize, z = 1}
 local pmapminpxz = {x = minp.x, y = minp.z}
 local c_stone= minetest.get_content_id("default:stone")
 local layers= { 
             { min=-100, node="rocks:granite" },
             { min=-240, node="rocks:diorite"},
             { node="rocks:gabbro", min=-700},
            }
 for k,v in pairs(layers) do
  v.ctx=minetest.get_content_id(v.node)
 end
 local layers_no=#layers
 local n_layer= minetest.get_perlin_map(np_layer, pmapsize) : get2dMap_flat(pmapminpxz)
 local n_intr= minetest.get_perlin_map(np_intr, pmapsize) : get2dMap_flat(pmapminpxz)
 local nixz= 1
 
 for z=minp.z, maxp.z do for x=minp.x, maxp.x do
  -- loop
  for y=minp.y, maxp.y do
   local di=area:index(x,y,z)
   local yn=y+n_layer[nixz]
   local vintr=n_intr[nixz]
   if vintr<1 then vintr=1 end
   if data[di]==c_stone then
    yn=yn*vintr -- vertical intrusion
    for li=1, layers_no do
     if yn > layers[li].min then
      data[di]=layers[li].ctx
      break
     end
    end
   end
  end
  nixz= nixz+1
 end end

 vm:set_data(data)
 --DEBUG: vm:set_lighting({day=15,night=2})
 minetest.generate_ores(vm)
 vm:write_to_map(data)
 minetest.log("action", "rocks/layer/ "..math.ceil((os.clock() - t1) * 1000).." ms ")
end)


-- ~ Tomas Brod