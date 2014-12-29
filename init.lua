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

rocks.noiseparams_layers = {
        offset = 0,
        scale = 1,
        spread = {x=300, y=300, z=300},
        octaves = 3,
        persist = 0.63
}

rocks.register_layer=function(name,params,rock)
 assert(name)
 assert(params)
 assert(params.gain)
 assert(params.height)
 local maxheight
 for ln,ld in pairs(rocks.layers) do
  if (ld.height<params.height)and ((not ld.maxheight) or (ld.maxheight>params.height)) then ld.maxheight=params.height end
  if (ld.height>params.height)and((not maxheight) or (maxheight>ld.height)) then maxheight=ld.height end
 end
 rocks.layers[name]= {
  gain=params.gain,
  height=params.height,
  maxheight=maxheight,
  limit=params.limit,
  seed=params.seed,
  rock={ block=rock },
  veins={}
 }
 print("[rocks] register layer "..name)
end

rocks.register_rock=function(layer,block,amount)
 assert(layer)
 assert(block)
 assert(amount)
 assert(rocks.layers[layer])
 table.insert(rocks.layers[layer].rocks, { block=block, amount=amount})
 rocks.layers[layer].sum=rocks.layers[layer].sum+amount
 print("[rocks] register rock "..block.." in "..layer.." amount="..amount.." cur sum="..rocks.layers[layer].sum)
end

--
-- test layer
--

rocks.register_layer("test1",{ gain=40, height=70, limit=2, seed=1 },"rocks:black_granite")

-- uhlie ako vrstva je kokotina.

rocks.register_layer("test3",{ gain=40, height=65, limit=2, seed=3 },"rocks:pink_granite")

rocks.register_layer("test4",{ gain=40, height=90, limit=2, seed=4 },"rocks:white_granite")


for ln,ld in pairs(rocks.layers) do
 print("[rocks] debug: "..ln..": "..minetest.serialize(ld))
end

--
-- layer generator
--

local function mknoises(layers,minp,maxp)
 local nm={}
 for ln,ld in pairs(rocks.layers) do
  if (ld.height-ld.gain<maxp.y)and((not ld.maxheight)or(ld.maxheight+ld.gain>minp.y)) then
   local np=rocks.noiseparams_layers
   np.seed=ld.seed
   local side_length = maxp.x - minp.x + 1
   ld.nmap=minetest.get_perlin_map(np,{x=side_length, y=side_length, z=side_length}):get2dMap({x=minp.x, y=minp.z})
   table.insert(nm,ld)
  end
 end
 return nm
end

local function mkheightmap(layers,x,z,minp,maxp)
 local hm={}
 for ln,ld in pairs(layers) do
   local noise=ld.nmap[z-minp.z+1][x-minp.x+1]
   if math.abs(noise)<ld.limit then
    ld.nh = (noise*ld.gain)+ld.height
    -- if (ld.nh<maxy)and(ld.nh>miny)
    table.insert(hm,ld)
   end
 end
 return hm
end

local stonectx=nil

minetest.register_on_generated(function(minp, maxp, seed)
 if not stonectx then stonectx= minetest.get_content_id("default:stone") end
 -- noise values range (-1;+1) (1 octave)
 -- 3 octaves it is like 1.7 max
 -- 4 octaves with 0.8 presist = 2.125 max !!
 -- if ...
 local timebefore=os.clock();
 local manipulator, emin, emax = minetest.get_mapgen_object("voxelmanip")
 local nodes = manipulator:get_data()
 local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
 -- initialize noises and sort out unused layers
 local availlayers=mknoises(rocks.layers,minp,maxp)
 --
 for x=minp.x,maxp.x,1 do
  for z=minp.z,maxp.z,1 do
   --* initialize layers hmap
   local layers=mkheightmap(availlayers,x,z,minp,maxp)
   if (minp.x>0)and(minp.x<200) then layers=nil end --< debug
   if layers then for y=minp.y,maxp.y,1 do
    
    --* select layer
    local layer
    for ln,ld in pairs(layers) do
     if (ld)and
        (ld.nh<y)and
        ((not layer)or(ld.height>layer.height))
     then
      layer=ld
     end
    end
    
    --* select vein
    local vein=nil
    if layer then
     -- vein=todo... iterate vein's noises and select one above it's treshold
    end
    
    --* select rock
    local rock=nil
    if vein then
     rock=nil -- todo... --> based on pseudorandom, no pattern, just random
    elseif layer then
     rock=layer.rock -- not in vein > select base rock
    end
    
    --* place rocks
    if rock then
     if not rock.ctx then
      rock.ctx=minetest.get_content_id(rock.block)
     end
     local p_pos = area:index(x, y, z)
     nodes[p_pos] = rock.ctx
    end
    
   end end
  end
 end
 manipulator:set_data(nodes)
 -- manipulator:calc_lighting()
 -- manipulator:update_liquids()
 manipulator:write_to_map()
 print("[rocks] gen "..os.clock()-timebefore)
 
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

print("[rocks] loaded.")
