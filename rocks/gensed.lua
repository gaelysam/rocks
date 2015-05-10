-- experimental sedimentary layer generator

local np_elv = {
 offset = 0, octaves = 2, persist = 0.4,
 scale = 8,
 spread = {x=25, y=25, z=25},
 seed = -546,
}
local np_typ1 = {
 offset = 0, octaves = 2, persist = 0.33,
 scale = 1,
 spread = {x=50, y=50, z=50},
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
 spread = {x=150, y=150, z=150},
 seed = -1284,
}

local stats
stats={ total=0 }

rocksl.gensed = function (minp, maxp, seed)
 local t1 = os.clock()
 local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
 local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
 local data = vm:get_data()

 local chunksize = maxp.x - minp.x + 1
 local pmapsize = {x = chunksize, y = chunksize, z = chunksize}
 local minpxz = {x = minp.x, y = minp.z}
 local c_stone= minetest.get_content_id("default:stone")
 local c_dwg= c_stone

 local sla = {
  {min=18, sd=169},
  {min=9, sd=324},
  {min=0, sd=-230},
  {min=-6, sd=850},
  {min=-12, sd=-643},
  {min=-18, sd=0},
 }
 if minp.y<(sla[#sla].min-10) then return end
 local biomes = {
  lava={ mod="default" },
  nyancat={ mod="default" },
  wood={ mod="default" },
  gravel={ mod="default" },
  sand={ mod="default" },
  sandstone={ mod="default" },
  clay={ mod="default" },
  claystone={ mod="rocks" },
  slate={ mod="rocks" },
  conglomerate={ mod="rocks" },
  mudstone={ mod="rocks" },
  limestone={ mod="rocks" },
  blackcoal={ mod="rocks" },
  lignite={ mod="rocks" },
  anthracite={ mod="rocks" },
 }
 for k,v in pairs(biomes) do
  v.ctx=v.ctx or minetest.get_content_id(v.mod..":"..k)
  if stats and (stats[k]==nil) then stats[k]=0 end
 end
 n_elv= minetest.get_perlin_map(np_elv, pmapsize) : get2dMap_flat(minp)
 
 local generated
 local nixz= 0
 local nixyz= 0
 for z=minp.z, maxp.z do for x=minp.x, maxp.x do
  nixz= nixz+1
  -- loop
  local bi
  local li
  for y=maxp.y, minp.y, -1 do
   nixyz=nixyz+1
   local di=area:index(x,y,z)
   local yn=y +n_elv[nixz]
   if (data[di]==c_stone) and ((not bi)or(yn<sla[li].min)) then
    -- go to deeper layer
    if not li then li=1 end
    while (li<=#sla)and(sla[li].min>yn) do
     li=li+1
    end
    -- create noises for this layer
    if li>#sla then break end -- break y loop if too low
    if (not sla[li].n_tp1) then
     local altminpxz={ x=minp.x+sla[li].sd,
                          y=minp.z-sla[li].sd}
     sla[li].n_tp1= minetest.get_perlin_map(np_typ1, pmapsize) : get2dMap_flat(altminpxz)
     sla[li].n_tp2= minetest.get_perlin_map(np_typ2, pmapsize) : get2dMap_flat(altminpxz)
     sla[li].n_vc= minetest.get_perlin_map(np_vc, pmapsize) : get2dMap_flat(altminpxz)
     sla[li].n_sp= minetest.get_perlin_map(np_sp, pmapsize) : get2dMap_flat(altminpxz)
    end
  -- BEGIN geome resolution
  local vcva= math.abs(sla[li].n_vc[nixz])
  local vcv= sla[li].n_vc[nixz]
  local spv= sla[li].n_sp[nixz]
  local tp=1 --=particulates, 2=biosediments, 3=chemosediments, 4=vulcanosediments
  if sla[li].n_tp1[nixz]>0.2 then tp=2
   if sla[li].n_tp2[nixz]>0.81 then tp=4 end
  elseif sla[li].n_tp2[nixz]>0.76 then tp=3 end

  if tp==1 then
   -- particulates
   if vcva>0.453 then
    -- clay-(0,stone,slate)
    if spv>0.23 then bi="slate"
    elseif spv>-0.2 then bi="claystone"
    else bi="clay" end
   elseif vcva>0.4 then
    bi="mudstone"
   elseif vcva>0.2 then
    -- sand-(0,stone)
    if spv>-0.3 then bi="sandstone" else bi="sand" end
   else
    -- gravel/conglomerate
    if spv>-0.34 then bi="conglomerate" else bi="gravel" end
    -- breccia?
   end
  elseif tp==2 then
   -- biosediments
   if vcv>0.05 then
    bi="limestone"
   elseif vcv>-0.1 then
    --uhlia
    if spv>0.7 then bi="anthracite"
    elseif spv>0 then bi="blackcoal"
    else bi="lignite" end
   else
    --ine
    bi="wood"
   end
  end

  -- END geome resolution

    if not bi then bi="nyancat" end
    generated=true
   end
   if (data[di]==c_stone) then
    data[di]=biomes[bi].ctx
    if stats then stats.total=stats.total+1 stats[bi]=stats[bi]+1 end
   end
  end
 end end
 if generated then
  vm:set_data(data)
  vm:write_to_map(data)
  if stats then for k,v in pairs(stats) do  print("stat: "..k..": "..((v/stats.total)*100).."%") end end
 else
  print("no sed layer y="..minp.y)
 end
 minetest.log("action", "rocks/gensed/ "..math.ceil((os.clock() - t1) * 1000).." ms ")
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

minetest.register_node( "rocks:lignite", {
	description = S("Lignite coal"),
	tiles = { "rocks_Mudstone.png^rocks_lignite.png" },
	is_ground_content = true,
	groups = {crumbly=3},
})
minetest.register_node( "rocks:blackcoal", {
	description = S("Black coal"),
	tiles = { "rocks_Mudstone.png^default_mineral_coal.png" },
	is_ground_content = true,
	groups = {crumbly=3},
})
minetest.register_node( "rocks:anthracite", {
	description = S("Anthracite coal"),
	tiles = { "rocks_Mudstone.png^rocks_anthracite.png" },
	is_ground_content = true,
	groups = {crumbly=3},
})
