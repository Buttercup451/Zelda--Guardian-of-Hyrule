local map = ...
local game = map:get_game()

local init_evil_tiles = sol.main.load_file("maps/evil_tiles")
init_evil_tiles(map)

local light_manager = require("maps/lib/light_manager")

function map:on_started()
  map:set_doors_open("door_3")
  teletransporter:set_enabled(false)
  map:set_entities_enabled("invisible_switch_", false)
  map:set_doors_open("door_5")
  map:set_entities_enabled("evil_tile_", false)
  map:set_entities_enabled("stairs_", false)
  light_manager.enable_light_features(map)
  map:set_doors_open("door_dark_room_seal")
end

function auto_separator_3:on_activated(direction3)
  map:set_light(0)-- Puts the map into the dark.
end

function switch_door:on_activated()
  map:open_doors("door_2")
end

function door_3_sensor:on_activated()
  map:close_doors("door_3")
end

function door_4_a:on_opened()
  map:open_doors("door_4_b")
end

function teletransporter_switch:on_activated()
  teletransporter:set_enabled(true)
end

function door_5_sensor:on_activated()
  map:close_doors("door_5")
  sol.timer.start(2500, function()
    map:start_evil_tiles()
  end)
  door_5_sensor:set_enabled(false)
end

function map:finish_evil_tiles()
  map:set_entities_enabled("invisible_switch_", true)
end

function invisible_switch_sensor:on_activated_repeat()
  local switch_1 = invisible_switch_1:is_activated()
  local switch_2 = invisible_switch_2:is_activated()

  if switch_1 == true then
    if switch_2 == true then
      map:open_doors("door_5")
      map:open_doors("door_6")
      sol.audio.play_sound("secret")
      invisible_switch_sensor:set_enabled(false)
      map:set_entities_enabled("stairs_", true)
    end
  end
end

function door_dark_room_seal_sensor:on_activated()
  map:close_doors("door_dark_room_seal")
end