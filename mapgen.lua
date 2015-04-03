--
-- layer generator
--

local print2=function(text)
 minetest.log("verbose","rocks/gen/ "..text)
end

rocksl.seedseq=0
rocksl.GetNextSeed=function()
 rocksl.seedseq=rocksl.seedseq+20
 print2("seed "..rocksl.seedseq)
 return rocksl.seedseq
end

rocksl.register_blob=function(layer,name,param)
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

rocksl.layergen=function(layer, minp, maxp, seed)
 if   ( (layer.top.offset+layer.top.scale)>minp.y )
  and ( (layer.bot.offset-layer.bot.scale)<maxp.y )
 then
  stone_ctx= minetest.get_content_id("default:stone")
  air_ctx= minetest.get_content_id("air")
  dirt_ctx= minetest.get_content_id("default:dirt")
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

-- ~ Tomas Brod