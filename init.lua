-- Load translation library if intllib is installed

if (minetest.get_modpath("intllib")) then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	S = intllib.Getter(minetest.get_current_modname())
	else
	S = function ( s ) return s end
end

rocks={}

local modpath=minetest.get_modpath(minetest.get_current_modname())

print("[rocks] begin")

dofile(modpath.."/sed.lua")

minetest.register_on_mapgen_init(function(mapgen_params)
 -- todo: disable caves and ores
 print("[rocks] mapgen initalized ")
end)

print("[rocks] done")