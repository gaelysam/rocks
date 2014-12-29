-- global table and register_* functions

rocks = {}

rocks.layers = {}
rocks.veins = {}
rocks.ores = {}

rocks.register_layer=function(name,params,rock)
 assert(name)
 assert(params)
 assert(params.gain)
 assert(params.height)
 local maxheight
 for ln,ld in pairs(rocks.layers) do
  if (ld.height<params.height)and ((not ld.maxheight) or (ld.maxheight>params.height)) then ld.maxheight=params.height end
  if (ld.height>params.height)and((not maxheight) or (maxheight>ld.height)) then maxheight=ld.height end
 end
 rocks.layers[name]= {
  gain=params.gain,
  height=params.height,
  maxheight=maxheight,
  limit=params.limit,
  seed=params.seed,
  rock={ node=rock },
  veins={}
 }
 print("[rocks] layer "..name)
end

rocks.register_vein=function(name,params)
 assert(name)
 assert(params)
 assert(not rocks.veins[name])
 rocks.veins[name]={
  np={
   offset=0, scale=1, octaves=1, presist=0.8,
   spread={x=params.spread.y, y=params.spread.z, z=params.spread.x}, 
   -- swapped, becouse we generate by horizontal layers
   seed=params.seed
  },
  treshold=params.treshold,
  hmin=params.hmin, hmax=params.hmax,
  layers=params.layers,
  ores={}
 }
 for ln,ld in pairs(rocks.layers) do
  ld.veins[name]=rocks.veins[name]
 end
 print("[rocks] vein "..name)
end

rocks.register_ore=function( vein, node, params )
 -- params= {treshold=0,    chance=1  }
 ore={ node=node }
 ore.treshold=(params.treshold or rocks.veins[vein].treshold)
 ore.chance= (params.chance or 1)
 table.insert(rocks.veins[vein].ores, ore)
 print("[rocks] ore "..node.." in "..vein.." chance="..ore.chance.." treshold="..ore.treshold)
end
