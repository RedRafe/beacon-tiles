local lib = require '__beacon-tiles__.lib'
local effect = lib.get_bonus

local allow_productivity = settings.startup['bt:allow_productivity'].value
local lite_mode = settings.startup['bt:lite_mode'].value

local module_info =
{
  ['default']               = { tile = "concrete",         tint = { r = 047, g = 079, b = 079 } }, -- #2F4F4F
  
  ['effectivity-module']    = { tile = "stone-path",       tint = { r = 220, g = 250, b = 200 } },
  ['effectivity-module-2']  = { tile = "concrete",         tint = { r = 185, g = 225, b = 165 } },
  ['effectivity-module-3']  = { tile = "refined-concrete", tint = { r = 150, g = 200, b = 130 } },

  ['speed-module']          = { tile = "stone-path",       tint = { r = 200, g = 220, b = 255 } },
  ['speed-module-2']        = { tile = "concrete",         tint = { r = 165, g = 215, b = 255 } },
  ['speed-module-3']        = { tile = "refined-concrete", tint = { r = 130, g = 180, b = 230 } },

  ['productivity-module']   = { tile = "stone-path",       tint = { r = 250, g = 180, b = 120 } },
  ['productivity-module-2'] = { tile = "concrete",         tint = { r = 225, g = 130, b = 090 } },
  ['productivity-module-3'] = { tile = "refined-concrete", tint = { r = 200, g = 080, b = 060 } },

  ['ll-quantum-module']     = { tile = "refined-concrete", tint = { r = 133, g = 094, b = 130 } }, -- #855E82
}

-- == TILES ===================================================================

local layer = 1

-- Make module-tiles
for _, mod in pairs(data.raw.module) do
  local effects = mod.effect or {}  
  if math.abs(effect(effects, 'productivity')) > 0 then
    if not allow_productivity then
      goto continue
    end
  end

  local info = module_info[mod.name] or module_info.default
  local tile = table.deepcopy(data.raw.tile[info.tile])

  if mod.icons and mod.icons[1] and mod.icons[1].tint then
    info.tint = mod.icons[1].tint
  end

  if not tile then
    goto continue
  end
  
  tile.name = mod.name
  tile.localised_name = {'', {'item-name.'..mod.name}}
  tile.tint = info.tint
  tile.order = mod.order
  tile.layer = math.min(254, tile.layer + layer)
  tile.map_color = info.tint
  tile.minable.result = tile.name
  -- reference original transition tables so that they keep referencing global water_tile_type_names
  tile.transitions = tile.transitions
  tile.transitions_between_transitions = tile.transitions_between_transitions

  tile.walking_speed_modifier = (tile.walking_speed_modifier or 1) + effect(effects, 'speed') - effect(effects, 'consumption')
  tile.vehicle_friction_modifier = (tile.vehicle_friction_modifier or 1) + effect(effects, 'speed') - effect(effects, 'consumption')
  tile.pollution_absorption_per_second = (tile.pollution_absorption_per_second or 0) - effect(effects, 'pollution') - effect(effects, 'productivity')

  data:extend{tile}

  if lite_mode then
    mod.place_as_tile =
    {
      result = tile.name,
      condition = { "water-tile" },
      condition_size = 1
    }
  else
    --lib.make_recipe(tile, info.tile)
    --lib.make_item(tile, info.tile)
  end

  layer = layer + 1

  ::continue::
end

-- == BEACONS =================================================================

-- Prevent players from blueprinting beacons, if disabled
if not settings.startup['bt:allow_beacons'].value then
  for _, beacon in pairs(data.raw.beacon) do
    beacon.flags = beacon.flags or {}
    table.insert(beacon.flags, "not-blueprintable")
  end
end

-- Make 1x1 tile beacon
data:extend({
  {
    type = "beacon",
    name = "tile-beacon",
    
    icons = {
      {
        icon = "__base__/graphics/icons/beacon.png",
        icon_size = 64,
        icon_mipmaps = 4,
      },
      {
        icon = "__base__/graphics/icons/refined-concrete.png",
        icon_size = 64,
        icon_mipmaps = 4,
        scale = 0.25,
        shift = {8, -8}
      }
    },
    flags = { "not-on-map", "not-in-kill-statistics", "hidden", "hide-alt-info", "not-selectable-in-game", "placeable-off-grid", "no-automated-item-removal", "no-automated-item-insertion"},
    collision_mask = {},
    remove_decoratives = true,
    --selectable_in_game = false,
    --collision_box = {{-0.45, -0.45}, {0.45, 0.45}},
    --selection_box = {{-0.45, -0.45}, {0.45, 0.45}},
    hidden = true,
    allowed_effects = {"consumption", "speed", "pollution"},
    radius_visualisation_picture =
    {
      filename = "__base__/graphics/entity/beacon/beacon-radius-visualization.png",
      priority = "extra-high-no-scale",
      width = 10,
      height = 10
    },
    supply_area_distance = 1,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "54kW",--"480kW",
    distribution_effectivity = 0.5,
    module_specification =
    {
      module_slots = 1,
    },
  },
})

if allow_productivity then
  table.insert(data.raw.beacon['tile-beacon'].allowed_effects, 'productivity')
end

-- ============================================================================
