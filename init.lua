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
 print("[rocks] "..text)
end

local modpath=minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/mapgen.lua")
dofile(modpath.."/sed.lua")
dofile(modpath.."/ign.lua")
dofile(modpath.."/skarn.lua")

minetest.register_on_mapgen_init(function(mapgen_params)
 -- todo: disable caves and ores
end)
