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
   table.insert(avl,d) -- pridame ju
   if (d.height-d.gain)>maxp.y then break end -- ak je mimo zhora tak uz dalsie nehladaj
  else
   --print(" no higher "..d.height.." than "..minp.y)
  end
 end

 --
 print("[rocks] afterinit "..os.clock()-timebefore.." #layers="..#avl)
    for lh,ld in ipairs(avl) do
    print(" "..lh.."->"..ld.name)
    end

 local noise2d_ix = 1
 local noise3d_ix = 1

 for x=minp.x,maxp.x,1 do
  for z=minp.z,maxp.z,1 do
   for y=minp.y,maxp.y,1 do
    local p_pos = area:index(x, y, z)
    local layer,rock
    
    --* select layer
    for lh,ld in ipairs(avl) do
     if y<ld.nmap[noise2d_ix] then
      layer=ld
      rock=layer.rock
      break
     end
    end
    
    --* place rocks
    if (rock) and(nodes[p_pos]==stone_ctx) then
     nodes[p_pos] = rock.ctx
    end
   
    noise3d_ix =noise3d_ix+1
   end
   noise2d_ix = noise2d_ix+1
  end
 end
 manipulator:set_data(nodes)
 manipulator:calc_lighting()
 manipulator:update_liquids()
 manipulator:write_to_map()
 print("[rocks] gen "..os.clock()-timebefore)
end)

