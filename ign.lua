--
-- Igneous Layer
--

local layer={
 top={
  offset = -13, scale = 0,
  spread = {x=80, y=80, z=80},
  octaves = 0, persist = 0 },
 bot={
  offset = -180, scale = 10, seed=100,
  spread = {x=80, y=80, z=80},
  octaves = 2, persist = 0.7 },
 primary={ name="rocks:basalt" },
 localized={},
 seedseq=100,
 stats={ count=0, total=0, node={}, totalnodes=0 }
}

-- more rock defs


local reg=function(name,param)
 layer.localized[name]={
  spread=(param.spread or 20),
  height=(param.height or 15),
  treshold=(param.treshold or 0.85),
  secondary=(param.secondary),
  seed=seedseq,
 }
 layer.stats.node[name]=0
 layer.seedseq=layer.seedseq+1
end
rocks.register_igneous=reg

-- rock registration
 --eg: reg("default:stone_with_coal", { spread=48, height=14, treshold=0.45 })

minetest.register_on_generated(function(minp, maxp, seed)
 if   ( (layer.top.offset+layer.top.scale)>minp.y )
  and ( (layer.bot.offset-layer.bot.scale)<maxp.y )
 then
  stone_ctx= minetest.get_content_id("default:stone")
  air_ctx= minetest.get_content_id("air")
  dirt_ctx= minetest.get_content_id("default:dirt")
  layer.primary.ctx= minetest.get_content_id(layer.primary.name)
  local timebefore=os.clock();
  local manipulator, emin, emax = minetest.get_mapgen_object("voxelmanip")
  local nodes = manipulator:get_data()
  local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
  local side_length = (maxp.x - minp.x) + 1
  local map_lengths_xyz = {x=side_length, y=side_length, z=side_length}
  -- noises:
  local bottom=minetest.get_perlin_map(layer.bot,map_lengths_xyz):get2dMap_flat({x=minp.x, y=minp.z})
  local localized={}
  for name,loc in pairs(layer.localized) do
   --defaults and overrides
   local np={ offset = 0, scale = 1, octaves = 1, persist = 0.7,
    spread = {x=loc.spread, y=loc.height, z=loc.spread} }
   --get noise and content ids
   table.insert(localized,
   {
    noise=minetest.get_perlin_map(np,map_lengths_xyz):get3dMap_flat(minp),
    treshold=loc.treshold,
    ctx= minetest.get_content_id(name),
    ndn=name
   })
  end
  local noise2d_ix = 1
  local noise3d_ix = 1
  print("[rocks] igneous gen1 "..os.clock()-timebefore)
  for z=minp.z,maxp.z,1 do
   for y=minp.y,maxp.y,1 do
    for x=minp.x,maxp.x,1 do
     local pos = area:index(x, y, z)
     if  (y>bottom[noise2d_ix])
     and ((nodes[pos]==stone_ctx) or (nodes[pos]==dirt_ctx))
     then
      layer.stats.totalnodes=layer.stats.totalnodes+1
      if nodes[pos]==stone_ctx then nodes[pos] = air_ctx end --layer.primary.ctx
      for k,loc in pairs(localized) do
       if ( loc.noise[noise3d_ix] > loc.treshold) then
        nodes[pos]=loc.ctx
        layer.stats.node[loc.ndn]=layer.stats.node[loc.ndn]+1
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
  manipulator:set_data(nodes)
  --manipulator:calc_lighting()
  manipulator:set_lighting({day=15,night=15})
  --manipulator:update_liquids()
  manipulator:write_to_map()
  print("[rocks] igneous gen2 "..os.clock()-timebefore)
  layer.stats.count=layer.stats.count+1
  layer.stats.total=layer.stats.total+(os.clock()-timebefore)
  layer.stats.side=side_length
 end
end)

minetest.register_on_shutdown(function()
 print("[rocks](ign) on_shutdown: generated total "..layer.stats.count.." chunks in "..layer.stats.total.." seconds ("..(layer.stats.total/layer.stats.count).." seconds per "..layer.stats.side.."^3 chunk)")
 for name,total in pairs(layer.stats.node) do
  print("[rocks](ign) "..name..": "..total.." nodes placed ("..(total*100)/(layer.stats.count*layer.stats.totalnodes).." %)")
 end
end)

-- ~ Tomas Brod