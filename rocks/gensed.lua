-- experimental sedimentary layer generator

local np_typ = {
 offset = 0, octaves = 2, persist = 0.33,
 scale = 1,
 spread = {x=70, y=70, z=70},
 seed = -5500,
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
 spread = {x=220, y=220, z=220},
 seed = -1284,
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
 local c_dwg= minetest.get_content_id("default:dirt_with_grass")

 local n_typ= minetest.get_perlin_map(np_typ, pmapsize) : get2dMap_flat(pmapminpxz)
 local n_vc= minetest.get_perlin_map(np_vc, pmapsize) : get2dMap_flat(pmapminpxz)
 local n_sp= minetest.get_perlin_map(np_sp, pmapsize) : get2dMap_flat(pmapminpxz)
 
 layers = {
  { node="default:sand" },
  { node="default:dirt" },
  { node="default:wood" },
  { node="default:obsidian" },
 }
 for k,v in pairs(layers) do
  v.ctx=minetest.get_content_id(v.node)
 end
 
 local nixz= 1
 for z=minp.z, maxp.z do for x=minp.x, maxp.x do
  -- loop
  local tpv= math.abs(n_typ[nixz])
  local vcv= math.abs(n_vc[nixz])
  local spv= math.abs(n_sp[nixz])
  local tp=1
  if tpv>0.45 then tp=2 end
  if tpv>0.78 then tp=3 end
  if tpv>0.94 then tp=4 end
  li=tp
  for y=minp.y, maxp.y do
   local di=area:index(x,y,z)
   if (data[di]==c_stone) or (data[di]==c_dwg) then
    data[di]=layers[li].ctx
   end
  end
  nixz= nixz+1
 end end
 vm:set_data(data)
 vm:write_to_map(data)
 minetest.log("action", "rocks/gensed/ "..math.ceil((os.clock() - t1) * 1000).." ms ")
end
