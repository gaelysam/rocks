-- experimental fast pipe generator

local pr

local function draw_sphere(data,area,pos,radius,with)
 local rsq=radius^2
 radius=radius+2
 for x=-radius, radius do
 for y=-radius, radius do
 for z=-radius, radius do
  if (x^2)+(y^2)+(z^2)<=rsq then
   data[area:index(x+pos.x,y+pos.y,z+pos.z)]=with
  end
 end end end
end

rocksl.genpipe=function(minp,maxp,seed,vm,area)
 local t1 = os.clock()
 local data = vm:get_data()

 local chunksizer = maxp.x - minp.x + 1
 local chunksize = chunksizer + 1
 local pmapsize = {x = chunksize, y = chunksize, z = chunksize}
 local minpxz = {x = minp.x, y = minp.z}
 pr=pr or PseudoRandom(seed)
 local c_sample=minetest.get_content_id("default:mese")
 local sample_scarcity=16
 
 local numpipes_raw=(chunksize/sample_scarcity)
 local numpipes = math.floor(numpipes_raw + (pr:next(0,99)/100))
 print("numpipes="..numpipes.." raw="..numpipes_raw)
 print("pr="..pr:next().." seed="..seed)
 print("minp="..minp.x..","..minp.y..","..minp.z)
 print("maxp="..maxp.x..","..maxp.y..","..maxp.z)
 --local pointA=vector.add(minp,chunksize/2)
 --local pointA=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
 --draw_sphere(data,area,pointA,5,c_sample)

 for vc=1, numpipes do
  local pointA=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  local pointB=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  local pointC=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  print("pointA="..pointA.x..","..pointA.y..","..pointA.z)
  print("pointB="..pointB.x..","..pointB.y..","..pointB.z)
  print("pointC="..pointC.x..","..pointC.y..","..pointC.z)
  local step=1.41/(vector.distance(pointA,pointB)+vector.distance(pointB,pointC))
  print("step="..step)
  for t=0, 1, step do
   local p=vector.multiply(pointA,(1-t)^2)
   p=vector.add(p, vector.multiply(pointB,2*t*(1-t)) )
   p=vector.add(p, vector.multiply(pointC,t*t) )
   --local p=vector.add(vector.multiply(pointA,(1-t)), vector.multiply(pointB,t) )
   p=vector.round(p)
   local di=area:index(p.x,p.y,p.z)
   data[di]=c_sample
   --draw_sphere(data,area,p,1,c_sample)
  end
 end

 vm:set_data(data)
 minetest.log("action", "rocks/genpipe/ "..math.ceil((os.clock() - t1) * 1000).." ms ")
end