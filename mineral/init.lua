--
-- The minerals mod.
--

minetest.log("info","/mineral mod initializing")

-- Load translation library if intllib is installed

if (minetest.get_modpath("intllib")) then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	S = intllib.Getter(minetest.get_current_modname())
	else
	S = function ( s ) return s end
end

mineral={}
mineral.noise={}

local print=function(text)
 minetest.log("info","/mineral "..text)
end

local modpath=minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/skarn.lua")

