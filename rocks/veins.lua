-- experimental fast vein generator

rocks.veins={}

table.insert(rocks.veins,{
 scarcity=80,
 
})


rocksl.genvein=function(minp,maxp,pr,vm,area)
 local t1 = os.clock()
 local data = vm:get_data()

 local chunksizer = maxp.x - minp.x + 1
 local chunksize = chunksizer + 1
 local pmapsize = {x = chunksize, y = chunksize, z = chunksize}
 local minpxz = {x = minp.x, y = minp.z}
 local c_sample=minetest.get_content_id("default:stone")
 local c_sample_ore=minetest.get_content_id("default:mese")
 

  local A=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  local B=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  local C=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  local D=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  local l1=vector.distance(A,C)+vector.distance(C,B)
  local l2=vector.distance(A,D)+vector.distance(D,B)
  local step=1.4/math.max(l1,l2)
  print("step="..step.." l1="..l1.." l2="..l2)
  local scarcity=6
  local ocn=pr:next(0,scarcity)+(scarcity/2)
  for t=0, 1, step do
   local P=vector.multiply(A,(1-t)^2)
   P=vector.add(P, vector.multiply(B,t*t) )
   local Q=vector.add(P, vector.multiply(D,2*t*(1-t)) )
   P=vector.add(P, vector.multiply(C,2*t*(1-t)) )
   local step2=1/vector.distance(P,Q)
   for u=0, 1, step2 do
    local R=vector.add(vector.multiply(P,(1-u)), vector.multiply(Q,u) )
    local di=area:indexp(vector.round(R))
    if ocn<1 then
     data[di]=c_sample_ore
     ocn=pr:next(0,scarcity)+(scarcity/2)
    else
     data[di]=c_sample
     ocn=ocn-1
    end
   end
  end

 vm:set_data(data)
 minetest.log("action", "rocks/genvein/ "..math.ceil((os.clock() - t1) * 1000).." ms ")
end