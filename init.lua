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

rocksl.seedseq=0
rocksl.GetNextSeed=function()
 rocksl.seedseq=rocksl.seedseq+20
 return rocksl.seedseq
end

local modpath=minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/sed.lua")
--dofile(modpath.."/ign.lua")
--dofile(modpath.."/skarn.lua")

minetest.register_on_mapgen_init(function(mapgen_params)
 -- todo: disable caves and ores
end)
