local map = ...
local game = map:get_game()

local light_manager = require("maps/lib/light_manager")

function map:on_started()
  light_manager.enable_light_features(map)
  map:set_light(0)
  map:set_doors_open("door_dark_room")
end

function dark_room_door_sensor:on_activated()
  map:close_doors("door_dark_room")
end