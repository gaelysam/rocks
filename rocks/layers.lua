local np_elv = {
 offset = -4, octaves = 2, persist = 0.4,
 scale = 28,
 spread = {x=25, y=25, z=25},
 seed = -546,
}
local np_fault = {
 offset = -5, octaves = 2, persist = 0.4,
 scale = 10,
 spread = {x=25, y=25, z=25},
 seed = 632,
}

rocksl.genlayers = function (minp, maxp, seed, vm, area)
 local t1 = os.clock()
 local data = vm:get_data()

 local chunksize = maxp.x - minp.x + 1
 local pmapsize = {x = chunksize, y = chunksize, z = chunksize}
 local minpxz = {x = minp.x, y = minp.z}
 local c_stone= minetest.get_content_id("default:stone")
 local c_sample=minetest.get_content_id("rocks:samplelayerblock")
 local c_air=minetest.get_content_id("air")

 n_elv= minetest.get_perlin_map(np_elv, pmapsize) : get2dMap_flat(minpxz)
 n_fault= minetest.get_perlin_map(np_fault, pmapsize) : get2dMap_flat(minpxz)
 
 local nixz=1
 for z=minp.z, maxp.z do for x=minp.x, maxp.x do

  local fault=n_fault[nixz]
  local lmh=-10
  if fault>0 then lmh=lmh+10 end
  local lt=math.floor(n_elv[nixz])
  if lt>0 then
   if lt>18 then lt=18 end
   local top=math.min(lmh,maxp.y)
   local bot=math.max(1+lmh-lt,minp.y)
   for y=bot, top do
    local di=area:index(x,y,z)
    data[di]=c_sample
   end
  end

  nixz=nixz+1
  if z%100>50 then
   for y=minp.y, maxp.y do data[area:index(x,y,z)]=c_air end
  end

 end end
 vm:set_data(data)
 vm:set_lighting({day=15,night=15})
 minetest.log("action", "rocks/genlayers/ "..math.ceil((os.clock() - t1) * 1000).." ms ")
end

minetest.register_node( "rocks:samplelayerblock", {
	description = S("Sample"),
	tiles = { "rocks_Slate.png" },
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
	groups = {cracky=3},
})
