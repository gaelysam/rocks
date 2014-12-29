--
-- layer generator
--

local function mknoises(layers,minp,maxp,seed)
 local nm={}
 for ln,ld in pairs(rocks.layers) do
  if (ld.height-ld.gain<maxp.y)and((not ld.maxheight)or(ld.maxheight+ld.gain>minp.y)) then
   local np=rocks.noiseparams_layers
   np.seed=ld.seed
   local side_length = (maxp.x - minp.x) + 1
   local map_lengths_xyz = {x=side_length, y=side_length, z=side_length}
   ld.nmap=minetest.get_perlin_map(np,map_lengths_xyz):get2dMap({x=minp.x, y=minp.z})
   local vidx=1
   for vn,vd in pairs(ld.veins) do
    -- todo check if hmax,hmin is in current block
    vd.onmap=minetest.get_perlin_map(vd.np,map_lengths_xyz):get3dMap_flat(minp)
    vidx=vidx+1
   end
   table.insert(nm,ld)
  end
 end
 return nm
end

local function mkheightmap(layers,x,z,minp,maxp)
 local hm={}
 for ln,ld in pairs(layers) do
   local noise=ld.nmap[z-minp.z+1][x-minp.x+1]
   if math.abs(noise)<ld.limit then
    ld.nh = (noise*ld.gain)+ld.height
    -- if (ld.nh<maxy)and(ld.nh>miny)
    table.insert(hm,ld)
   end
 end
 return hm
end

local stonectx=nil

minetest.register_on_generated(function(minp, maxp, seed)
 if not stone_ctx then stone_ctx= minetest.get_content_id("air") end
 -- noise values range (-1;+1) (1 octave)
 -- 3 octaves it is like 1.7 max
 -- 4 octaves with 0.8 presist = 2.125 max !!
 local timebefore=os.clock();
 local manipulator, emin, emax = minetest.get_mapgen_object("voxelmanip")
 local nodes = manipulator:get_data()
 local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
 -- initialize noises and sort out unused layers
 local availlayers=mknoises(rocks.layers,minp,maxp,seed)
 local perlin_index = 1
 --
 for x=minp.x,maxp.x,1 do
  for z=minp.z,maxp.z,1 do
   --* initialize layers hmap
   local layers=mkheightmap(availlayers,x,z,minp,maxp)
   if (minp.x>0)and(minp.x<200) then layers=nil end --< debug
   if layers then for y=minp.y,maxp.y,1 do
    
    local p_pos = area:index(x, y, z)
    
    --* select layer
    local layer
    for ln,ld in pairs(layers) do
     if (ld)and
        (ld.nh<y)and
        ((not layer)or(ld.height>layer.height))
     then
      layer=ld
     end
    end
    
    --* select vein
    local vein=nil
    if layer then
     for vn,vd in pairs(layer.veins) do
      if ((not vd.hmin) or y>vd.hmin)
         and((not vd.hmax) or y<vd.hmax)
         and(vd.onmap[perlin_index]>vd.treshold)
      then
       vein=vd
      end
     end
     --if vein then print("[rocks] generate vein") end
    end
    
    --* select rock
    local rock=nil
    if vein then
     for von,vod in pairs(vein.ores) do
      if not vod.pr then vod.pr=PseudoRandom(seed+von) end
      if (vein.onmap[perlin_index]>vod.treshold)
         and(vod.pr:next(0,1)<=vod.chance) --< todo add pseudorandom chance
         and( (not rock) or 
          (vod.treshold>=rock.treshold
           -- or vod.chance<=rock.chance works better with this disabled
          )
         )
      then
       rock=vod
      end
     end
    end
    if (not rock) and layer then
     rock=layer.rock -- not in vein? > select base rock
    end
    
    --* place rocks
    if (rock) and(nodes[p_pos]==stone_ctx) then
     if not rock.ctx then
      rock.ctx=minetest.get_content_id(rock.node)
     end
     nodes[p_pos] = rock.ctx
    end
   
    perlin_index =perlin_index+1
   end end
  end
 end
 manipulator:set_data(nodes)
 -- manipulator:calc_lighting()
 -- manipulator:update_liquids()
 manipulator:write_to_map()
 print("[rocks] gen "..os.clock()-timebefore)
end)
