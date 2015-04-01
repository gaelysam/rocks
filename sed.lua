--
-- Sedimentary Layer
--

local sed={
 top={
  offset = 20, scale = 0,
  spread = {x=80, y=80, z=80},
  octaves = 0, persist = 0 },
 bot={
  offset = -22, scale = 10, seed=1,
  spread = {x=80, y=80, z=80},
  octaves = 2, persist = 0.7 },
 primary={ name="rocks:mudstone" },
 localized={},
 seedseq=2,
 stats={ count=0, total=0, node={}, totalnodes=0 }
}

-- Mudstone     Sed        soft  Ocean, beach, river, glaciers
minetest.register_node( "rocks:mudstone", {  
	description = S("Mudstone"),
	tiles = { "rocks_Mudstone.png" },
	groups = {cracky=1, crumbly=1}, 
	is_ground_content = true, sounds = default.node_sound_dirt_defaults(),
})

-- more rock defs
minetest.register_node( "rocks:limestone", {  
	description = S("Limestone"),
	tiles = { "rocks_Limestone.png" },
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
	groups = {cracky=2},
})


local reg=function(name,param)
 sed.localized[name]={
  spread=(param.spread or 20),
  height=(param.height or 15),
  treshold=(param.treshold or 0.85),
  secondary=(param.secondary),
  seed=seedseq,
 }
 sed.stats.node[name]=0
 sed.seedseq=sed.seedseq+1
end
rocks.register_sedimentary=reg

--               Sedimentary rock hardness and distribution
--    Rock      Hard                      Distribution
--Breccia      Weak   Localized continental, folded
-->Claystone    Weak   Localized continental, folded, oceanic
--Conglomerate Weak   Localized continental, folded
-->Limestone    Medium Localized continental, folded; primary oceanic, hills
-->Coal         -      Large beds, twice as common in swamps
 reg("rocks:limestone",    { spread=64, height=32, treshold=0.56 })
 --reg("rocks:breccia",  { spread=64, height=32, treshold=0.6 })
 --reg("rocks:conglomerate", { spread=64, height=32, treshold=0.6 })
 reg("default:clay",{ spread=24, height=16, treshold=0.63 })
 reg("default:stone_with_coal", { spread=48, height=14, treshold=0.45 })

minetest.register_on_generated(function(minp, maxp, seed)
 if   ( (sed.top.offset+sed.top.scale)>minp.y )
  and ( (sed.bot.offset-sed.bot.scale)<maxp.y )
 then
  stone_ctx= minetest.get_content_id("default:stone")
  air_ctx= minetest.get_content_id("air")
  dirt_ctx= minetest.get_content_id("default:dirt")
  sed.primary.ctx= minetest.get_content_id(sed.primary.name)
  local timebefore=os.clock();
  local manipulator, emin, emax = minetest.get_mapgen_object("voxelmanip")
  local nodes = manipulator:get_data()
  local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
  local side_length = (maxp.x - minp.x) + 1
  local map_lengths_xyz = {x=side_length, y=side_length, z=side_length}
  -- noises:
  local bottom=minetest.get_perlin_map(sed.bot,map_lengths_xyz):get2dMap_flat({x=minp.x, y=minp.z})
  local localized={}
  for name,loc in pairs(sed.localized) do
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
  print("[rocks] sedimentary gen1 "..os.clock()-timebefore)
  for z=minp.z,maxp.z,1 do
   for y=minp.y,maxp.y,1 do
    for x=minp.x,maxp.x,1 do
     local pos = area:index(x, y, z)
     if  (y>bottom[noise2d_ix])
     and ((nodes[pos]==stone_ctx) or (nodes[pos]==dirt_ctx))
     then
      sed.stats.totalnodes=sed.stats.totalnodes+1
      if nodes[pos]==stone_ctx then nodes[pos] = air_ctx end --sed.primary.ctx
      for k,loc in pairs(localized) do
       if ( loc.noise[noise3d_ix] > loc.treshold) then
        nodes[pos]=loc.ctx
        sed.stats.node[loc.ndn]=sed.stats.node[loc.ndn]+1
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
  print("[rocks] sedimentary gen2 "..os.clock()-timebefore)
  sed.stats.count=sed.stats.count+1
  sed.stats.total=sed.stats.total+(os.clock()-timebefore)
  sed.stats.side=side_length
 end
end)

minetest.register_on_shutdown(function()
 print("[rocks](sed) on_shutdown: generated total "..sed.stats.count.." chunks in "..sed.stats.total.." seconds ("..(sed.stats.total/sed.stats.count).." seconds per "..sed.stats.side.."^3 chunk)")
 for name,total in pairs(sed.stats.node) do
  print("[rocks](sed) "..name..": "..total.." nodes placed ("..(total*100)/(sed.stats.count*sed.stats.totalnodes).." %)")
 end
end)

-- ~ Tomas Brod