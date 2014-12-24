-- Load translation library if intllib is installed

local S
if (minetest.get_modpath("intllib")) then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	S = intllib.Getter(minetest.get_current_modname())
	else
	S = function ( s ) return s end
end

rocks = {}

rocks.layers = {}
rocks.veins = {}
rocks.ores = {}

rocks.layer_gain=40
rocks.layer_scale=500
rocks.layer_presist=0.7
rocks.layer_octaves=3

rocks.rock_scale=3
rocks.rock_presist=0.5
rocks.rock_octaves=1 -- faster than 2 ?

rocks.register_layer=function(name,params)
 assert(name)
 assert(params)
 assert(params.gain)
 assert(params.height)
 rocks.layers[name]= {
  gain=params.gain,
  height=params.height,
  sum=0,
  rocks={}
 }
 print("[rocks] register layer "..name)
end

rocks.register_rock=function(layer,block,amount)
 assert(layer)
 assert(block)
 assert(amount)
 assert(rocks.layers[layer])
 table.insert(rocks.layers[layer].rocks, { block=block, amount=amount, placed=0})
 rocks.layers[layer].sum=rocks.layers[layer].sum+amount
 print("[rocks] register rock "..block.." in "..layer.." amount="..amount.." cur sum="..rocks.layers[layer].sum)
end

--
-- test layer
--

rocks.register_layer("test",{ gain=10, height=100 })
rocks.register_rock("test","rocks:black_granite",1)
rocks.register_rock("test","rocks:brown_granite",1)
rocks.register_rock("test","rocks:pink_granite",1)
rocks.register_rock("test","rocks:white_granite",1)

--
-- layer generator
--

local noise_layer=nil
local noise_rock=nil
local noise_vein=nil
local noise_ore=nil
local stonectx=nil

local function get_layer(y,noise)
 return bln
end

minetest.register_on_generated(function(minp, maxp, seed)
 if noise_layer==nil then noise_layer=minetest.get_perlin(353, rocks.layer_octaves, rocks.layer_presist, rocks.layer_scale) end
 if noise_rock==nil then noise_rock=minetest.get_perlin(354, rocks.rock_octaves, rocks.rock_presist, rocks.rock_scale) end
 if not stonectx then stonectx= minetest.get_content_id("default:stone") end
 -- noise values range (-1;+1) (1 octave)
 -- 3 octaves it is like 1.7 max
 -- 4 octaves with 0.8 presist = 2.125 max !!
 -- if ...
 print("[rocks] generate y="..minp.y)
 local timebefore=os.clock();
 local manipulator, emin, emax = minetest.get_mapgen_object("voxelmanip")
 local nodes = manipulator:get_data()
 local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
 local maxrnoise=-500
 local minrnoise=500
 local perlin=nil
 for x=minp.x,maxp.x,1 do
  for z=minp.z,maxp.z,1 do
   perlin=noise_layer:get2d( {x=x, y=z} )
   noise=perlin*rocks.layer_gain
   local curlh=-31000 -- top height of current layer
   local curln=nil -- name of current layer
   local layer=nil
   for y=minp.y,maxp.y,1 do
    -- select current layer
    if (not layer)or((y+noise)>curlh) then
     curlh=-31000
     curln=nil
     for ln,ld in pairs(rocks.layers) do
      if (ld.height>curlh)and(y+noise>ld.height) then
       curln=ln
       curlh=ld.height
      end
     end
     layer=rocks.layers[curln]
    end
    if layer then
    -- noise for rocks
    rnoise=noise_rock:get3d( {x=x, y=y, z=z} )
    if rnoise>maxrnoise then maxrnoise=rnoise end
    if rnoise<minrnoise then minrnoise=rnoise end
    -- noise is mainly -1+2, but sometimes may go further
    rnoise=(rnoise+1)*(layer.sum/2)
    if rnoise<0 then rnoise=0 end
    if rnoise>layer.sum then rnoise=layer.sum end
    -- select current rock
    local rofs=0
    for rn,rd in pairs(layer.rocks) do
     if (rnoise>=rofs) and (rnoise<rofs+rd.amount) then
      rockix=rn
     end
     rofs=rofs+rd.amount
    end
    -- place rocks
     local p_pos = area:index(x, y, z)
     if (nodes[p_pos]==stonectx)or true then
      local cr=layer.rocks[rockix].block
      local ctx=layer.rocks[rockix].blockctx
      layer.rocks[rockix].placed=layer.rocks[rockix].placed+1
      if not ctx then
       ctx= minetest.get_content_id(cr)
       layer.rocks[rockix].blockctx= ctx
      end
      nodes[p_pos] = ctx
     end
    end
   end
  end
 end
 print("[rocks] manipulator flush")
 manipulator:set_data(nodes)
 -- manipulator:calc_lighting()
 -- manipulator:update_liquids()
 manipulator:write_to_map()
 print("[rocks] gen "..os.difftime(os.clock(),timebefore).." perlin: "..minrnoise..".."..maxrnoise)
 
end)

minetest.register_on_shutdown( 
    function(playername, param)
     for layername,layer in pairs(rocks.layers) do
      for rockix,rock in pairs(layer.rocks) do
      print("[rock] stats"..minetest.serialize( {
        layer=layername,
        rock=rock
      }))
      end
     end
    end
  )

--
--Bedrock
--

minetest.register_node( "rocks:pink_granite", {  
	description = "Pink Granite",
	tiles = { "rocks_pgr.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:pink_granite",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=31, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:black_granite", {  
	description = "Black Granite",
	tiles = { "rocks_blkgr.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:black_granite",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=32, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:white_granite", {  
	description = "White Granite",
	tiles = { "rocks_wgr.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:white_granite",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=33, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:brown_granite", {  
	description = "Brown Granite",
	tiles = { "rocks_brgr.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:brown_granite",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=34, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:red_sandstone", {  
	description = "Red Sandstone",
	tiles = { "rocks_rss.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:red_sandstone",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=35, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:yellow_sandstone", {  
	description = "Yellow Sandstone",
	tiles = { "rocks_yss.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:yellow_sandstone",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=36, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:white_marble", {  
	description = "White Marble",
	tiles = { "rocks_wm.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:white_marble",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=37, octaves=11, persist=0.0000000001}
})

minetest.register_node( "rocks:black_basalt", {  
	description = "Black Basalt",
	tiles = { "rocks_bb.png" },
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:black_basalt",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 60,
		height_min     = -31000,
		height_max     = -46,
		noise_threshhold = 0.2,
		noise_params = {offset=0, scale=80, spread={x=4350, y=4350, z=4350}, seed=38, octaves=11, persist=0.0000000001}
})

minetest.register_ore({
		ore_type       = "sheet",
		ore            = "rocks:clay",
		wherein        = "do_not_generate",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 6,
		height_min     = -31000,
		height_max     = 15,
		noise_threshhold = 0.5,
		noise_params = {offset=0, scale=15, spread={x=25, y=20, z=30}, seed=15, octaves=3, persist=0.10}
})

minetest.register_abm({
        nodenames = {"default:stone"},
        interval = 10,
        chance = 1,
        action = function(pos, node)
                minetest.set_node(pos, {name="air"} )
        end
})

minetest.register_abm({
        nodenames = {"default:sand"},
        interval = 10,
        chance = 1,
        action = function(pos, node)
                minetest.set_node(pos, {name="air"} )
        end
})

print("[rocks] loaded.")
