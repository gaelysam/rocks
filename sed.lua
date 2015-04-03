--
-- Sedimentary Layer
--

local sed={
 top={
  offset = 20, scale = 0,
  spread = {x=80, y=80, z=80},
  octaves = 0, persist = 0 },
 bot={
  offset = -16, scale = 10, seed=rocksl.GetNextSeed(),
  spread = {x=80, y=80, z=80},
  octaves = 2, persist = 0.7 },
 primary={ name="rocks:mudstone" },
 localized={},
 stats={ count=0, total=0, node={}, totalnodes=0 },
 debugging=nil
}

-- Mudstone     Sed        soft  Ocean, beach, river, glaciers
minetest.register_node( "rocks:mudstone", {  
	description = S("Mudstone"),
	tiles = { "rocks_Mudstone.png" },
	groups = {cracky=1, crumbly=3}, 
	is_ground_content = true, sounds = default.node_sound_dirt_defaults(),
})

-- more rock defs
minetest.register_node( "rocks:limestone", {  
	description = S("Limestone"),
	tiles = { "rocks_Limestone.png" },
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
	groups = {cracky=2},
})


local reg=function(name,param)
 rocksl.register_stratus(sed,name,param)
end

rocks.register_sedimentary=reg

--               Sedimentary rock hardness and distribution
--    Rock      Hard                      Distribution
--Breccia      Weak   Localized continental, folded
-->Claystone    Weak   Localized continental, folded, oceanic
--Conglomerate Weak   Localized continental, folded
-->Limestone    Medium Localized continental, folded; primary oceanic, hills
-->Coal         -      Large beds, twice as common in swamps
 reg("rocks:limestone",    { spread=64, height=32, treshold=0.36 })
 --reg("rocks:breccia",  { spread=64, height=32, treshold=0.6 })
 --reg("rocks:conglomerate", { spread=64, height=32, treshold=0.6 })
 reg("default:stone_with_coal", { spread=48, height=14, treshold=0.40 })
 reg("default:clay",{ spread=48, height=14, treshold=0.50 })

minetest.register_on_generated(function(minp, maxp, seed)
 rocksl.layergen(sed,minp,maxp,seed)
end)

minetest.register_on_shutdown(function()
 if (sed.stats.count==0) then rocksl.print("[rocks](sed) stats not available, no chunks generated") return end
 rocksl.print("[rocks](sed) generated total "..sed.stats.count.." chunks in "..sed.stats.total.." seconds ("..(sed.stats.total/sed.stats.count).." seconds per "..sed.stats.side.."^3 chunk)")
 for name,total in pairs(sed.stats.node) do
  rocksl.print("[rocks](sed) "..name..": "..total.." nodes placed ("..(total*100)/(sed.stats.totalnodes).." %)")
 end
end)

-- ~ Tomas Brod