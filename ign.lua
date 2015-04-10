--
-- Igneous Layer
--

local ign={
 top={
  offset = -10, scale = 0,
  spread = {x=80, y=80, z=80},
  octaves = 0, persist = 0 },
 bot={
  offset = -180, scale = 10, seed=rocksl.GetNextSeed(),
  spread = {x=80, y=80, z=80},
  octaves = 2, persist = 0.7 },
 primary={ name="rocks:basalt" },
 localized={},
 stats={ count=0, total=0, node={}, totalnodes=0 },
 debugging=nil
}

-- Basalt       Ex/Mafic   hard  same as diorite, byt limit=0.5
minetest.register_node( "rocks:basalt", {  
	description = S("Basalt"),
	tiles = { "rocks_Basalt.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})

-- more rock defs
minetest.register_node( "rocks:granite", {  
	description = S("Granite"),
	tiles = { "rocks_Granite.png" },
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
	groups = {cracky=3, stone=1}, 
})
minetest.register_node( "rocks:diorite", {  
	description = S("Diorite"),
	tiles = { "rocks_Diorite.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
minetest.register_node( "rocks:gabbro", {  
	description = S("Gabbro"),
	tiles = { "rocks_Gabbro.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})

local reg=function(name,param)
 rocksl.register_stratus(ign,name,param)
end
rocks.register_igneous_stratus=reg

-- rock registration
 reg("rocks:granite", { spread=40, height=32, treshold=0.06})
 reg("rocks:diorite", { spread=40, height=32, treshold=0.23})
 reg("rocks:gabbro",  { spread=40, height=32, treshold=0.36})

-- vein stuff
ign.veins={}

local regv=function(name,param)
 rocksl.register_vein(ign.veins,name,param)
end
rocks.register_vein=regv

rocks.register_vein("default:nyancat",{
  wherein="rocks:granite",
  miny=-160, maxy=20,
  radius={ average=10, amplitude=4, frequency=8 },
  density=100,
  rarity=0.0025, -- this^3*mapblock_volume veins per mapblock
  ores={
    { ore="default:sand", percent=30 },
    { ore="default:dirt", percent=30 },
  }
  })


minetest.register_on_generated(function(minp, maxp, seed)
 rocksl.layergen(ign,minp,maxp,seed)
 rocksl.veingen(ign.veins,minp,maxp,seed)
end)

minetest.register_on_shutdown(function()
 if (ign.stats.count==0) then rocksl.print("[rocks](ign) stats not available, no chunks generated") return end
 rocksl.print("[rocks](ign) generated total "..ign.stats.count.." chunks in "..ign.stats.total.." seconds ("..(ign.stats.total/ign.stats.count).." seconds per "..ign.stats.side.."^3 chunk)")
 for name,total in pairs(ign.stats.node) do
  rocksl.print("[rocks](ign) "..name..": "..total.." nodes placed ("..(total*100)/(ign.stats.totalnodes).." %)")
 end
end)

-- ~ Tomas Brod