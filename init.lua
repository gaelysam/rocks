-- Load translation library if intllib is installed

if (minetest.get_modpath("intllib")) then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	S = intllib.Getter(minetest.get_current_modname())
	else
	S = function ( s ) return s end
end

local modpath=minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/register.lua")

rocks.noiseparams_layers = {
        offset = 0,
        scale = 1,
        spread = {x=80, y=80, z=80},
        octaves = 2,
        persist = 0.7
}

dofile(modpath.."/mapgen.lua")
dofile(modpath.."/geologica.lua")


print("[rocks] loaded.")
