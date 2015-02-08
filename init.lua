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
--dofile(modpath.."/testing.lua")
dofile(modpath.."/geologica.lua")
dofile(modpath.."/geologica_nv.lua")

print("[rocks] sorting layers")

for i,d in pairs(rocks.layers_name) do table.insert(rocks.layers,d) end
table.sort(rocks.layers,function(a,b)
 return a.height<b.height
end)

for i,d in pairs(rocks.layers) do
 print(" init,layer "..i.." "..minetest.serialize(d))
end

print("[rocks] loaded.")
