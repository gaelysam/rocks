-- experimental sedimentary layer generator

local np_typ1 = {
 offset = 0, octaves = 2, persist = 0.33,
 scale = 1,
 spread = {x=70, y=70, z=70},
 seed = -5500,
}
local np_typ2 = {
 offset = 0, octaves = 2, persist = 0.33,
 scale = 1,
 spread = {x=70, y=70, z=70},
 seed = -5472,
}
local np_vc = {
 offset = 0, octaves = 2, persist = 0.33,
 scale = 1,
 spread = {x=100, y=100, z=100},
 seed = 749,
}
local np_sp = {
 offset = 0, octaves = 2, persist = 0.33,
 scale = 1,
 spread = {x=100, y=100, z=100},
 seed = -1284,
}

local stats={
  dirt=0,
  gravel=0,
  sand=0,
  sandstone=0,
  clay=0,
  claystone=0,
  slate=0,
  conglomerate=0,
  mudstone=0,
  total=0
}

rocksl.gensed = function (minp, maxp, seed)
 local t1 = os.clock()
 local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
 local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
 local data = vm:get_data()

 local chunksize = maxp.x - minp.x + 1
 local pmapsize = {x = chunksize, y = chunksize, z = chunksize}
 local pmapminpxz = {x = minp.x, y = minp.z}
 local c_stone= minetest.get_content_id("rocks:mudstone")
 local c_dwg= c_stone
 --DEBUG: c_dwg= minetest.get_content_id("default:dirt_with_grass")

 local n_tp1= minetest.get_perlin_map(np_typ1, pmapsize) : get2dMap_flat(pmapminpxz)
 local n_tp2= minetest.get_perlin_map(np_typ2, pmapsize) : get2dMap_flat(pmapminpxz)
 local n_vc= minetest.get_perlin_map(np_vc, pmapsize) : get2dMap_flat(pmapminpxz)
 local n_sp= minetest.get_perlin_map(np_sp, pmapsize) : get2dMap_flat(pmapminpxz)
 
 local layers = {
  dirt={ mod="default" },
  gravel={ mod="default" },
  sand={ mod="default" },
  sandstone={ mod="default" },
  clay={ mod="default" },
  claystone={ mod="rocks" },
  slate={ mod="rocks" },
  conglomerate={ mod="rocks" },
  mudstone={ mod="rocks" },
 }
 for k,v in pairs(layers) do
  v.ctx=minetest.get_content_id(v.mod..":"..k)
 end
 
 local nixz= 1
 for z=minp.z, maxp.z do for x=minp.x, maxp.x do
  -- loop
  local li
  local vcv= math.abs(n_vc[nixz])
  local spv= n_sp[nixz]
  local tp=1 --=particulates, 2=biosediments, 3=chemosediments, 4=vulcanosediments
  if n_tp1[nixz]>0.5 then tp=2
   if n_tp2[nixz]>0.7 then tp=4 end
  elseif n_tp2[nixz]>0.7 then tp=3 end

  if tp==1 then
   -- particulates
   if vcv>0.46 then
    -- clay-(0,stone,slate)
    if spv>0.28 then li="slate"
    elseif spv>-0.31 then li="claystone"
    else li="clay" end
   elseif spv>0.4 then
    li="mudstone"
   elseif vcv>0.2 then
    -- sand-(0,stone)
    if spv>-0.3 then li="sandstone" else li="sand" end
   else
    -- gravel/conglomerate
    if spv>-0.34 then li="conglomerate" else li="gravel" end
    -- breccia?
   end
  end

  for y=minp.y, maxp.y do
   local di=area:index(x,y,z)
   if ((data[di]==c_stone) or (data[di]==c_dwg)) and li then
    data[di]=layers[li].ctx
    --stats.total=stats.total+1
    --stats[li]=stats[li]+1
   end
  end
  nixz= nixz+1
 end end
 vm:set_data(data)
 minetest.log("action", "rocks/gensed/ "..math.ceil((os.clock() - t1) * 1000).." ms ")
 vm:write_to_map(data)
 --for k,v in pairs(stats) do  print("stat: "..k..": "..((v/stats.total)*100).."%") end
end

minetest.register_node( "rocks:slate", {
	description = S("Slate"),
	tiles = { "rocks_Slate.png" },
	is_ground_content = true, sounds = default.node_sound_dirt_defaults(),
	groups = {cracky=3},
})
minetest.register_node( "rocks:claystone", {
	description = S("Claystone"),
	tiles = { "rocks_claystone.png" },
	is_ground_content = true, sounds = default.node_sound_dirt_defaults(),
	groups = {crumbly=1, cracky=3},
})

minetest.register_node( "rocks:conglomerate", {
	description = S("Conglomerate"),
	tiles = { "rocks_conglomerate.png" },
	is_ground_content = true, sounds = default.node_sound_dirt_defaults(),
	groups = {crumbly=3},
})
