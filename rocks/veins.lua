-- experimental fast vein generator

rocksl.genvein=function(minp,maxp,seed,vm,area)
 local t1 = os.clock()
 local data = vm:get_data()

 local chunksize = maxp.x - minp.x + 1
 local pmapsize = {x = chunksize, y = chunksize, z = chunksize}
 local minpxz = {x = minp.x, y = minp.z}
 local pr=PseudoRandom(seed)
 local c_sample=minetest.get_content_id("default:mese")
 
 local numveins_raw=(chunksize/8)
 local numveins = numveins_raw + (pr:next(-100,100)/100)
 local numveins = 1
 print("numveins="..numveins)

 for vc=1, numveins do
  local pointA=vector.new(pr:next(minp.x,maxp.x),pr:next(minp.x,maxp.x),pr:next(minp.x,maxp.x))
  local pointB=vector.new(pr:next(minp.x,maxp.x),pr:next(minp.x,maxp.x),pr:next(minp.x,maxp.x))
  local dir=vector.subtract(pointB,pointA)
  local step=(1/vector.length(dir))
  --vectorA=vector.add(pointA,minp)
  for t=0, 1, step do
   local p=vector.add(pointA, vector.multiply(dir,t) )
   p=vector.round(p)
   local di=area:index(p.x,p.y,p.z)
   data[di]=c_sample
  end
 end

 vm:set_data(data)
 minetest.log("action", "rocks/genvein/ "..math.ceil((os.clock() - t1) * 1000).." ms ")
end