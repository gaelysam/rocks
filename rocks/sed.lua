--
-- Sedimentary Layer
--

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
minetest.register_node( "rocks:laterite", {
	description = S("Laterite clay"),
	tiles = { "rocks_laterite.png" },
	is_ground_content = true, sounds = default.node_sound_dirt_defaults(),
	groups = {crumbly=3},
})

local beach_max=4
local lowland_max=27
local highland_max=200
local beach_min=-7
local lowland_min=5
local highland_min=28

do
 -- Modify default grassland biome
 local grassland=minetest.registered_biomes["default:grassland"] or
  { -- default biome, if no biome mod is installed
   name = "rocks:grassland",
   node_top = "air",
   depth_top = 0,
   depth_filler=0,
   y_min = lowland_min,
   y_max = lowland_max,
   heat_point = 50,
   humidity_point = 50,
  }
  local mountains={ -- default mountain biome
                name = "rocks:mountain",
                node_top = "default:dirt_with_grass",
                depth_top = 1,
                node_filler = "default:dirt",
                depth_filler = 2,
                node_stone = nil,
                y_min = highland_min,
                y_max = highland_max,
                heat_point = 50,
                humidity_point = 50,
  }
  -- The biome layers are: dust, top, filler, stone
  -- On beach: dust, shore_top, shore_filler, underwater
  -- coastside: dust, top, filler, shore_filler, underwater, stone
 if #minetest.registered_biomes > 1 then
  minetest.log("error","Biomes registered before [rocks] discarded, please depend the mod on 'rocks' to fix this.")
  -- can't just re-register them here, cause clear_biomes also clears decorations
 end
 minetest.clear_registered_biomes()
 -- hook to inject our sedimentary stone to new biomes
 local old_register_biome=minetest.register_biome
 minetest.register_biome=function(def)
  --print("[rocks] register_biome .name="..def.name)
  for n,v in pairs(def) do
   --if type(v)~="table" then print("   "..n.."="..v) end
  end
  local cor=false -- was the biomeheight patched?
  local tl=3 -- tolerance  in determining biome type based on y_min/max values
  local btype -- biome type (:string)
  if (def.y_max>3000) and (def.y_min<=highland_min)  then
   -- correct upper boundary of registered bimes
   if (def.y_min<10) and (def.y_min>0) then def.y_max=lowland_max cor=true end
   if (def.y_min<30) and (def.y_min>10) then def.y_max=highland_max cor=true end
   minetest.log("action","/rocks correcting upper bound on biome "..def.name.." to "..def.y_max)
  end
  -- actual detection code
  if def.node_stone=="default:desert_stone" then btype="desert"
  elseif (def.y_min>beach_min-tl) and (def.y_max<beach_max+tl) then btype="beach"
  elseif (def.y_min>0) and (def.y_max<lowland_max+tl) then btype="lowland"
  elseif (def.y_min>highland_min-tl) and (def.y_max<highland_max+tl) then btype="highland"
  elseif (def.y_min<-3000) and (def.y_max<lowland_min+tl) then btype="ocean"
  else minetest.log("error", "/rocks could not guess elevation type for biome "..def.name) end
  rocksl.print("register_biome .name="..def.name.." -> btype="..btype)
  -- patch the new biomes with our rocks
  if btype=="lowland" then
   --def.node_filler="rocks:mudstone"
   --def.depth_filler=11
   --def.node_stone="rocks:granite"
   if (def.humidity_point>80) and (def.heat_point>80) then
    --def.node_filler="rocks:laterite"
   end
  elseif btype=="highland" then
   def.node_filler="rocks:limestone"
   def.node_stone="rocks:limestone"
   def.depth_filler=15
  elseif btype=="beach" then
   def.node_stone="rocks:granite"
   def.y_min=beach_min
   if def.heat_point<50 then
    def.node_top="default:gravel"
    def.node_filler="default:gravel"
    def.depth_filler=2
   elseif def.node_top=="default:sand" then
    if def.depth_top<2 then def.depth_top=3 end
    def.node_filler="default:sandstone"
    def.depth_filler=5
   end
  elseif btype=="ocean" then
   def.node_stone="rocks:basalt"
   def.node_top="default:gravel"
   def.node_filler="rocks:limestone"
  end
  do -- deactivate the added and removed shore-thing of MGv7
   -- to fix weirid sand layers underground
   def.node_shore_top=def.node_top
   def.node_shore_filler=def.node_filler
   def.node_underwater=def.node_top
  end
  -- and call the saved method to actually do the registration
  old_register_biome(def)
 end
 --now register the default grassland
 minetest.register_biome(grassland)
 -- create a default mountain biome...
 minetest.register_biome(mountains)
 -- hook the clear callback (fix biomesdev)
 local old_clear=minetest.clear_registered_biomes
 minetest.clear_registered_biomes=function()
  old_clear()
  minetest.log("action","/rocks re-registering default mountain biome!")
  minetest.register_biome(mountains)
 end
end

-- more biomes
 -- todo: mountains, alps, volcanos



local reg=function(name,param)
 minetest.register_ore({
  ore=name,
  wherein= { 
         "rocks:mudstone",
         },
  ore_type         = "scatter",
  clust_scarcity   = 8^3,
  clust_size       = 10,
  clust_num_ores   = 10^3,
  y_min            = -20,
  y_max            = 40,
  noise_threshhold = param.treshold,
  noise_params     = {
          offset=0, scale=1, octaves=1, persist=0.3,
          spread={x=param.spread, y=param.height, z=param.spread},
          seed=rocksl.GetNextSeed(),
                     },
 })
end

-- this does register a new sedimentary vein.
rocks.register_sedimentary=reg

-- follows the only thing remaining from old ver :)

--               Sedimentary rock hardness and distribution
--    Rock      Hard                      Distribution
--Breccia      Weak   Localized continental, folded
-->Claystone    Weak   Localized continental, folded, oceanic
--Conglomerate Weak   Localized continental, folded
-->Limestone    Medium Localized continental, folded; primary oceanic, hills
-->Coal         -      Large beds, twice as common in swamps
 --reg("rocks:limestone",    { spread=64, height=32, treshold=0.35 })
 --reg("rocks:breccia",  { spread=64, height=32, treshold=0.6 })
 --reg("rocks:conglomerate", { spread=64, height=32, treshold=0.6 })
 --reg("default:stone_with_coal", { spread=64, height=14, treshold=0.58 })
 --reg("default:clay",{ spread=48, height=14, treshold=0.55 })

-- ~ Tomas Brod