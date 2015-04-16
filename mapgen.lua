--
-- layer generator
--

local print2=function(text)
 minetest.log("info","rocks/gen/ "..text)
end

rocksl.seedseq=0
rocksl.GetNextSeed=function()
 rocksl.seedseq=rocksl.seedseq+20
 print2("seed "..rocksl.seedseq)
 return rocksl.seedseq
end

local layers={}

rocks.layer_initialize=function(layer)
 layer.stats={ count=0, total=0, node={}, totalnodes=0 }
 table.insert(layers,layer)
end

rocksl.register_stratus=function(layer,name,param)
 table.insert(layer.localized,{
  primary=name,
  spread=(param.spread or 20),
  height=(param.height or 15),
  treshold=(param.treshold or 0.85),
  secondary=param.secondary,
  seed=(rocksl.GetNextSeed()),
 })
 layer.stats.node[name]=0
end

local veins={}

rocks.register_vein=function(name,param)
 local d={
   primary=name,
   wherein=param.wherein,
   miny=param.miny, maxy=param.maxy,
   radius={ average=param.radius.average, amplitude=param.radius.amplitude, frequency=param.radius.frequency },
   density=(param.density or 1),
   rarity=param.rarity,
   secondary=(param.ores or {}),
  }
 table.insert(veins,d)
end

-- TODO: rewrite above function to register normal minetest ore, with
-- special params, so the below func is not necesary. The mt oregen runs in 
-- separate therad (emerge) and it does not block server.
-- params: type=scatter scacrity=1 size=3 ores=27 : full chance of spawning, only limited by noise thr
-- EDIT: Need to edit mg_ore.cpp and Add following ore_types: layer, blob, region.
   -- layer=2Dheightmap style layer with specific thickness
   -- blob= 3D noise deformed sphere
   -- region= 3D noise / treshold ore placement.

rocksl.layergen=function(layer, minp, maxp, seed)
 if   ( (layer.top.offset+layer.top.scale)>minp.y )
  and ( (layer.bot.offset-layer.bot.scale)<maxp.y )
 then
  local stone_ctx= minetest.get_content_id("default:stone")
  local air_ctx= minetest.get_content_id("air")
  local dirt_ctx= minetest.get_content_id("default:dirt")
  if layer.debugging then 
   layer.primary.ctx= air_ctx
  else
   layer.primary.ctx= minetest.get_content_id(layer.primary.name)
  end
  local timebefore=os.clock();
  local manipulator, emin, emax = minetest.get_mapgen_object("voxelmanip")
  local nodes = manipulator:get_data()
  local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
  local side_length = (maxp.x - minp.x) + 1
  local map_lengths_xyz = {x=side_length, y=side_length, z=side_length}
  -- noises:
  local bottom=minetest.get_perlin_map(layer.bot,map_lengths_xyz):get2dMap_flat({x=minp.x, y=minp.z})
  local localized={}
  for _,loc in ipairs(layer.localized) do
   --defaults and overrides
   local np={ offset = 0, scale = 1, octaves = 1, persist = 0.7,
    spread = {x=loc.spread, y=loc.height, z=loc.spread}, seed=loc.seed}
   --get noise and content ids
   table.insert(localized,
   {
    noise=minetest.get_perlin_map(np,map_lengths_xyz):get3dMap_flat(minp),
    treshold=loc.treshold,
    ctx= minetest.get_content_id(loc.primary),
    ndn=loc.primary
   })
  end
  local noise2d_ix = 1
  local noise3d_ix = 1
  print2("after noise: "..(os.clock()-timebefore))
  for z=minp.z,maxp.z,1 do
   for y=minp.y,maxp.y,1 do
    for x=minp.x,maxp.x,1 do
     local pos = area:index(x, y, z)
     if  (y>bottom[noise2d_ix]) and (y<layer.top.offset)
     and ( (nodes[pos]==stone_ctx) or (nodes[pos]==dirt_ctx) )
     then
      layer.stats.totalnodes=layer.stats.totalnodes+1
      if nodes[pos]==stone_ctx then nodes[pos] = layer.primary.ctx end
      for k,loc in pairs(localized) do
       if ( loc.noise[noise3d_ix] > loc.treshold) then
        nodes[pos]=loc.ctx
        layer.stats.node[loc.ndn]=layer.stats.node[loc.ndn]+1
        break
       end
      end
     end
     noise2d_ix=noise2d_ix+1
     noise3d_ix=noise3d_ix+1
    end
    noise2d_ix=noise2d_ix-side_length
   end
   noise2d_ix=noise2d_ix+side_length
  end
  print2("after loop: "..(os.clock()-timebefore))
  manipulator:set_data(nodes)
  --manipulator:calc_lighting()
  --manipulator:update_liquids()
  if layer.debugging then 
   manipulator:set_lighting({day=15,night=15})
  end
  manipulator:write_to_map()
  print2("after commit: "..(os.clock()-timebefore))
  layer.stats.count=layer.stats.count+1
  layer.stats.total=layer.stats.total+(os.clock()-timebefore)
  layer.stats.side=side_length
 end
end

local ignore_wherein=nil

rocksl.veingen=function(veins,minp,maxp,seed)
 local side_length=(maxp.y-minp.y)
 local random=PseudoRandom(seed-79)
 local timebefore=os.clock();
 local manipulator, emin, emax = minetest.get_mapgen_object("voxelmanip")
 local nodes = manipulator:get_data()
 local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
 local did_generate=nil
 for _,vein in ipairs(veins) do
  if (minp.y<vein.maxy) and (maxp.y>vein.maxy) then
   local vr2=vein.radius.average^2
   local vrm=vein.radius.average+vein.radius.amplitude
   local noise_map=minetest.get_perlin_map(
    {
     seed=-79,
     scale=vein.radius.amplitude,
     offset=0, octaves=1, persist=0.7,
     spread={x=vein.radius.frequency, y=vein.radius.frequency, z=vein.radius.frequency}
    },{x=(vrm*2)+1, y=(vrm*2)+1, z=(vrm*2)+1}
   )
   local iterations_count= (vein.rarity*side_length)^3
   -- Resolve node names to id's
   iterations_count=iterations_count+(random:next(0,100)/100)
   local primary_ctx=minetest.get_content_id(vein.primary)
   for _,sec in pairs(vein.secondary) do sec.ctx=minetest.get_content_id(sec.ore) end
   --old:local wherein_ctx=minetest.get_content_id(vein.wherein)
   local wherein_set={}
   for _,wi in pairs(vein.wherein) do wherein_set[minetest.get_content_id(wi)]=true end
   --print("vein "..vein.primary.." ic="..iterations_count.." p="..primary_ctx)
   for iteration=1, iterations_count do
    local x0=minp.x+ random:next(0,side_length)
    local y0=minp.y+ random:next(0,side_length)
    local z0=minp.z+ random:next(0,side_length)
    local noise=noise_map:get3dMap_flat({x=x0-vrm, y=y0-vrm, z=z0-vrm})
    local noise_ix=1
    local posi = area:index(x0, y0, z0)
    if ignore_wherein or wherein_set[nodes[posi]] then
     print("vein "..vein.primary.." @ "..x0..","..y0..","..z0.." vrm="..vrm)
     did_generate=1
     for x=-vrm, vrm do
      for y=-vrm, vrm do
       for z=-vrm, vrm do
        local posc = {x=x+x0,y=y+y0,z=z+z0}
        posi = area:index(posc.x, posc.y, posc.z)
        local nv=noise[noise_ix]
        if (ignore_wherein or wherein_set[nodes[posi]]) and (((x^2)+(y^2)+(z^2))<((vein.radius.average+nv)^2)) then
         nodes[posi]=primary_ctx
         local luck=random:next(0,99)
         for _,sec in pairs(vein.secondary) do
          luck=luck-sec.percent
          if luck<=0 then 
           nodes[posi]=sec.ctx
           break
          end
         end
        end
        noise_ix=noise_ix+1
     end end end
    else
     --print("vein "..vein.primary.." bad environmnent -"..minetest.get_node({x0,y0,z0}).name.."="..nodes[posi])
    end
   end
  end
 end
 if did_generate then
  manipulator:set_data(nodes)
  --manipulator:calc_lighting()
  manipulator:write_to_map()
  print("end veingen "..(os.clock()-timebefore))
 else
  --print("end veingen (nothin generated)")
 end
end

minetest.register_on_generated(function(minp, maxp, seed)
 for _,layer in pairs(layers) do rocksl.layergen(layer,minp,maxp,seed) end
 rocksl.veingen(veins,minp,maxp,seed)
end)

minetest.register_on_shutdown(function()
 for _,ign in pairs(layers) do
  print("[rocks] Stats for layer "..ign.name)
  if (ign.stats.count==0) then
   print("[rocks] |- stats not available, no chunks generated")
  else
   print("[rocks] |- generated total "..ign.stats.count.." chunks in "..ign.stats.total.." seconds ("..(ign.stats.total/ign.stats.count).." seconds per "..ign.stats.side.."^3 chunk)")
   for name,total in pairs(ign.stats.node) do
    print("[rocks] |-  "..name..": "..total.." nodes placed ("..(total*100)/(ign.stats.totalnodes).." %)")
   end
  end
 end
end)

-- ~ Tomas Brod