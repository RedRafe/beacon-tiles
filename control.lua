local TILES = {}
local BEACON = 'tile-beacon'

local function centre(position)
  local center = {}
  center.x = position.x + 0.5
  center.y = position.y + 0.5
  return center
end

-- ============================================================================

local function update_module_list()
  global.modules = {}
  for _, item in pairs(game.item_prototypes) do
    if item.module_effects and next(item.module_effects) ~= nil then
      global.modules[item.name] = true
    end
  end

  TILES = global.modules
end

local function update_settings()
  global.allow_beacons = settings.startup['bt:allow_beacons'].value
end

local function on_init()
  global.modules = {}
  global.allow_beacons = false

  update_settings()
  update_module_list()
end

local function on_load()
  update_settings()
  TILES = global.modules
end

local function on_configuration_changed()
  update_settings()
  update_module_list()
end

script.on_init(on_init)
script.on_load(on_load)
script.on_configuration_changed(on_configuration_changed)
script.on_event(defines.events.on_runtime_mod_setting_changed, update_settings)

-- ============================================================================

local function on_built_tile(event)
  -- validate surface
  local surface = game.surfaces[event.surface_index]
  if not (surface and surface.valid) then
    return
  end

  local tile_new = event.tile.name
  local build_new = (TILES[tile_new] and true)
  
  for _, old in pairs(event.tiles or {}) do
    -- 1st, find any hidden beacon from old tiles
    if TILES[old.old_tile.name] then
      local beacon = surface.find_entity(BEACON, centre(old.position))
      if beacon then
        beacon.destroy()
      end
    end

    -- 2nd, if needed, create a new beacon
    if build_new then
      local beacon = surface.create_entity{
        name = BEACON,
        position = centre(old.position),
        force = 'player',
        raise_built = false
      }
      local inventory = beacon.get_module_inventory()
      inventory.insert(tile_new)
    end
  end
end

script.on_event(defines.events.on_player_built_tile,    on_built_tile)
script.on_event(defines.events.on_robot_built_tile,     on_built_tile)
script.on_event(defines.events.script_raised_set_tiles, on_built_tile)

-- ============================================================================

local function on_mined_tile(event)
  -- validate surface
  local surface = game.surfaces[event.surface_index]
  if not (surface and surface.valid) then
    return
  end

  for _, old in pairs(event.tiles) do
    if TILES[old.old_tile.name] then
      beacon = surface.find_entity(BEACON, centre(old.position))
      if beacon then
        beacon.destroy()
      end
    end
  end
end

script.on_event(defines.events.on_player_mined_tile, on_mined_tile)
script.on_event(defines.events.on_robot_mined_tile,  on_mined_tile)

-- ============================================================================

-- Drop item to ground if not allowed to build item
local function on_built_entity(event)
  if global.allow_beacons then
    return
  end

  local entity = event.created_entity
  if not (entity and entity.valid) then
    return
  end


  if entity.prototype.type ~= 'beacon' then
    return
  end

  local surface = entity.surface
  if not (surface and surface.valid) then
    return
  end

  local position = entity.position
  local item = entity.name
  entity.destroy()
  surface.spill_item_stack(position, { name = item, count = 1 }, true, nil, false)
end

local beacon_entities_filter = {{ filter = "type", type = "beacon" }}
script.on_event(defines.events.on_built_entity,       on_built_entity, beacon_entities_filter)
script.on_event(defines.events.on_robot_built_entity, on_built_entity, beacon_entities_filter)

-- ============================================================================
