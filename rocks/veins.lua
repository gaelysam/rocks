-- experimental fast vein generator

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

local function line(data,area,A,B,with)
 local length=vector.distance(A,B)
 local step=1/length
 for t=0, 1, step do
   local p=vector.add(vector.multiply(A,(1-t)), vector.multiply(B,t) )
   p=vector.round(p)
   data[area:index(p.x,p.y,p.z)]=with
 end
end

rocksl.genvein=function(minp,maxp,seed,vm,area)
 local t1 = os.clock()
 local data = vm:get_data()

 local chunksizer = maxp.x - minp.x + 1
 local chunksize = chunksizer + 1
 local pmapsize = {x = chunksize, y = chunksize, z = chunksize}
 local minpxz = {x = minp.x, y = minp.z}
 local pr=PseudoRandom(seed)
 local c_sample=minetest.get_content_id("default:mese")
 
 print("pr="..pr:next().." seed="..seed)
 print("minp="..minp.x..","..minp.y..","..minp.z)
 print("maxp="..maxp.x..","..maxp.y..","..maxp.z)

  local pointA=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  local pointB=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  local pointC=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  local pointB2=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  local l1=vector.distance(pointA,pointB)+vector.distance(pointB,pointC)
  local l2=1/(vector.distance(pointA,pointB2)+vector.distance(pointB2,pointC))
  local step=1.3/math.max(l1,l2)
  for t=0, 1, step do
   local p
   p=vector.multiply(pointA,(1-t)^2)
   p=vector.add(p, vector.multiply(pointC,t*t) )
   p=vector.add(p, vector.multiply(pointB,2*t*(1-t)) )
   local p2=vector.add(p, vector.multiply(pointB2,2*t*(1-t)) )
   line(data,area,p,p2,c_sample)
  end

 vm:set_data(data)
 minetest.log("action", "rocks/genvein/ "..math.ceil((os.clock() - t1) * 1000).." ms ")
end