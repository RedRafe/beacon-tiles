local lib = {}

-- ============================================================================

local function get_technology(item_name)
  for _, tech in pairs(data.raw.technology) do
    for _, effect in pairs(tech.effects or {}) do
      if effect.type == 'unlock-recipe' and effect.recipe == item_name then
        return tech
      end
    end
  end
  return nil
end

function lib.get_bonus(effect, t)
  return effect and effect[t] and effect[t].bonus or 0
end


function lib.make_recipe(tile, parent_tile_name)
end


function lib.make_item(tile, parent_tile_name)
end

-- ============================================================================


return lib