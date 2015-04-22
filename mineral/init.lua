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

local function GetNoiseParams()
 return {
  scale=1, offset=0, seed=rocksl.GetNextSeed(), octaves=1, persist=1,
  spread={ x=100, y=100, z=100 } }
end

mineral={}
mineral.noise={}

local print=function(text)
 minetest.log("info","/mineral "..text)
end

local modpath=minetest.get_modpath(minetest.get_current_modname())

mineral.noise.Copper=GetNoiseParams()
mineral.noise.PbZn=GetNoiseParams()
mineral.noise.Iron=GetNoiseParams()
mineral.noise.Tin=GetNoiseParams()

dofile(modpath.."/skarn.lua")
dofile(modpath.."/pegmatite.lua")

