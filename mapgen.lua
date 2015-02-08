--
-- layer generator
--


minetest.register_on_generated(function(minp, maxp, seed)
 stone_ctx= minetest.get_content_id("default:stone")
 air_ctx= minetest.get_content_id("air")
 local timebefore=os.clock();
 local manipulator, emin, emax = minetest.get_mapgen_object("voxelmanip")
 local nodes = manipulator:get_data()
 local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
 local side_length = (maxp.x - minp.x) + 1
 local map_lengths_xyz = {x=side_length, y=side_length, z=side_length}

 -- sort out unused layers
 -- generate noises
 avl={}
 for i,d in ipairs(rocks.layers) do
  -- h je normaalna vyyska horného konca vrstvy
  if (d.height+d.gain)>=minp.y then -- ak je to mimo zdola tak ju vyhodime
   -- urobime sum pre vrstvu
   local np=rocks.noiseparams_layers
   np.seed=d.seed
   np.scale=d.gain
   np.offset=d.height
   d.nmap=minetest.get_perlin_map(np,map_lengths_xyz):get2dMap_flat({x=minp.x, y=minp.z})
   -- contene_id kamenov
   d.rock.ctx=d.rock.ctx or minetest.get_content_id(d.rock.node)
   -- veiny
   local veinstodo={}
   for veinname,vd in pairs(d.veins) do
    -- todo: do not generate noise for blocks outside the layer
    veinstodo[veinname]=vd
   end
   for veinname,vd in pairs(veinstodo) do
    -- noise pre vein
    np=vd.np
    vd.nmap=minetest.get_perlin_map(np,map_lengths_xyz):get3dMap_flat(minp)
    vd.prng=nil
    vd.sum=0
    for i,ore in pairs(vd.ores) do
     -- contntid pre rudu
     ore.ctx=ore.ctx or minetest.get_content_id(ore.node)
     -- sum sanci pre vein
     vd.sum=vd.sum+ore.chance
    end
   end
   table.insert(avl,d) -- pridame vrstvu
   if (d.height-d.gain)>maxp.y then break end -- ak je mimo zhora tak uz dalsie nehladaj
  else
   --print(" no higher "..d.height.." than "..minp.y)
  end
 end

 --
 print("[rocks] gen2 "..os.clock()-timebefore.." #layers="..#avl.." minp.y="..minp.y.." maxp.y"..maxp.y)
    for lh,ld in ipairs(avl) do
    print(" "..lh.."->"..ld.name.." top="..ld.height)
     for vn,vd in pairs(ld.veins) do
      print("  "..vn.."->"..#vd.ores)
     end
    end

 local noise2d_ix = 1
 local noise3d_ix = 1

 for z=minp.z,maxp.z,1 do
  for y=minp.y,maxp.y,1 do
   for x=minp.x,maxp.x,1 do
    local p_pos = area:index(x, y, z)
    local layer,vein
    local rock
    
    --* select layer
    for lh,ld in ipairs(avl) do
     if (y<ld.nmap[noise2d_ix])and(ld.nmap[noise2d_ix]<ld.limit) then
      layer=ld
      rock=layer.rock
      break
     end
    end
    
    if layer then
     --* select vein
     for veinname,vd in pairs(layer.veins) do
      if vd.nmap[noise3d_ix]>vd.treshold then
       vein=vd
       --rock not changed
      end
     end
    end
    
    if vein then
     --* select ore
     for i,ore in pairs(vein.ores) do
      rock=ore
      break
     end
    end
    
    --* place rocks
    if (rock) and(nodes[p_pos]==stone_ctx) then
     nodes[p_pos] = rock.ctx
    end
   
    noise3d_ix =noise3d_ix+1
    noise2d_ix = noise2d_ix+1
   end
   noise2d_ix = noise2d_ix-side_length
  end
 end
 manipulator:set_data(nodes)
 manipulator:calc_lighting()
 manipulator:update_liquids()
 manipulator:write_to_map()
 print("[rocks] gen0 "..os.clock()-timebefore)
end)

