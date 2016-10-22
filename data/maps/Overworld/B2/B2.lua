local map = ...
local game = map:get_game()

local separator_manager = require("maps/lib/separator_manager.lua")
local stone_moved = game:get_value("fortune_teller_gravestone_moved")
local overworld_music = sol.audio.get_music()

function map:on_started()
  if overworld_music == "overworld_2" then
  else
    sol.audio.play_music("overworld_1", function()
      sol.audio.play_music("overworld_2", true)
    end)
  end
  separator_manager:manage_map(map)
  if stone_moved == true then
    map:set_entities_enabled("gravestone_moved", true)
    map:set_entities_enabled("gravestone_unmoved", false)
  else
    map:set_entities_enabled("gravestone_moved", false)
    map:set_entities_enabled("gravestone_unmoved", true)
  end
 local entrance_names = {
    "fortune_teller"
  }                               
  for _, entrance_name in ipairs(entrance_names) do
    local sensor = map:get_entity(entrance_name .. "_door_sensor")
    local tile = map:get_entity(entrance_name .. "_door")

    sensor.on_activated_repeat = function()
      if hero:get_direction() == 1
        and tile:is_enabled() then
        tile:set_enabled(false)
        sol.audio.play_sound("door_open")
      end
    end
  end
end

function gravestone_unmoved:on_moved()
  sol.audio.play_sound("secret")
  map:set_entities_enabled("gravestone_moved_stairs", true)
  game:set_value("fortune_teller_gravestone_moved", true)
end