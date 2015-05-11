minetest.log("info","[rocks] mod initializing")

-- Load translation library if intllib is installed

if (minetest.get_modpath("intllib")) then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	S = intllib.Getter(minetest.get_current_modname())
	else
	S = function ( s ) return s end
end

rocks={}
rocksl={}

rocksl.print=function(text)
 minetest.log("info","/rocks "..text)
end

rocksl.seedprng=PseudoRandom(763)
rocksl.GetNextSeed=function()
 return rocksl.seedprng:next()
end

minetest.clear_registered_ores()

local modpath=minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/sed.lua")
dofile(modpath.."/ign.lua")
dofile(modpath.."/skarn.lua")
dofile(modpath.."/pegmatite.lua")
dofile(modpath.."/gensed.lua")
dofile(modpath.."/pipes.lua")

minetest.register_on_generated(function(minp,maxp,seed)
 local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
 local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
 rocksl.gensed(minp,maxp,seed,vm,area)
 --rocksl.genign
 rocksl.genpipe(minp,maxp,seed,vm,area)
 vm:write_to_map(data)
end)

minetest.register_on_mapgen_init(function(mapgen_params)
 -- todo: disable caves and ores
end)
