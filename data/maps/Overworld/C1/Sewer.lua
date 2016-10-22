local map = ...
local game = map:get_game()

local light_manager = require("maps/lib/light_manager")

function map:on_started()
  sol.audio.set_music_volume(100)
  light_manager.enable_light_features(map)
  map:set_light(0)
end

function hero_lands_sensor:on_activated()
  sol.audio.play_sound("hero_lands")
  self:set_enabled(false)
end