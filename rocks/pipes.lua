-- experimental slow pipe generator

local function brush(data,area,pos,radius,content,ores,pr)
 local rsq=radius^2
 local orect
 local oresc
 radius=radius+2
   for _,ore in pairs(ores) do
    if pr:next(0,ore.scarcity)==0 then
     orect=ore.c_ore
     oresc=ore.density
    end
   end
 for x=-radius, radius do
 for y=-radius, radius do
 for z=-radius, radius do
  if (x^2)+(y^2)+(z^2)<=rsq then
   local di=area:index(x+pos.x,y+pos.y,z+pos.z)
   if oresc and (pr:next(0,oresc)==0) then 
    data[di]=orect
   else
    data[di]=content
   end
  end
 end end end
end

-- the public table of registered pipes
rocks.pipes={}
local examplepipe={
 bedrock={ "rocks:limestone" },
 startrock={ "rocks:limestone" },
 ymin=-200, ymax=-6,
 scarcity=80,
 radius=3,
 content="default:wood",
 scatter=
 {
  { scarcity=7, density=4, ore="default:mese", cnt=0},
 },
}
table.insert(rocks.pipes,examplepipe)
--profiling
table.insert(rocks.pipes,{
 bedrock={ "rocks:limestone" },
 startrock={ "rocks:limestone" },
 ymin=-200, ymax=-6,
 scarcity=80,
 radius=3,
 content="default:dirt",
 scatter=
 {
  { scarcity=5, density=4, ore="default:mese", cnt=0},
 },
})

rocksl.genpipe=function(minp,maxp,pr,vm,area,descr)
 local t1 = os.clock()
 local data = vm:get_data()

 local chunksizer = maxp.x - minp.x + 1
 local chunksize = chunksizer + 1
 local pmapsize = {x = chunksize, y = chunksize, z = chunksize}
 local minpxz = {x = minp.x, y = minp.z}
 
 local bedrocks={}
 for _,node in pairs(descr.bedrock) do bedrocks[minetest.get_content_id(node)]=true end
 local startrocks={}
 for _,node in pairs(descr.startrock) do startrocks[minetest.get_content_id(node)]=true end
 local content=minetest.get_content_id(descr.content)
 for _,des in pairs(descr.scatter) do 
  des.c_ore=minetest.get_content_id(des.ore)
 end
 local orepr=PseudoRandom(pr:next())

 local numpipes_raw=(chunksize/descr.scarcity)
 local numpipes = math.floor(numpipes_raw + (pr:next(0,99)/100))

 for vc=1, numpipes do
  local pointA=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  if (#startrocks>0)and(startrocks[data[area:indexp(pointA)]]==nil) then break end
  local pointB=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  local pointC=vector.new(pr:next(0,chunksizer)+minp.x,pr:next(0,chunksizer)+minp.y,pr:next(0,chunksizer)+minp.z)
  local step=(1.8*descr.radius)/(vector.distance(pointA,pointB)+vector.distance(pointB,pointC))
  for t=0, 1, step do
   local p=vector.multiply(pointA,(1-t)^2)
   p=vector.add(p, vector.multiply(pointB,2*t*(1-t)) )
   p=vector.add(p, vector.multiply(pointC,t*t) )
   p=vector.round(p)
   brush(data,area,p,descr.radius,content,descr.scatter,orepr)
  end
 end

 vm:set_data(data)
 minetest.log("action", "rocks/genpipe/ "..math.ceil((os.clock() - t1) * 1000).." ms ")
end