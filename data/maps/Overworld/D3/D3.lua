local map = ...
local game = map:get_game()

local overworld_music = sol.audio.get_music()

function map:on_started()
  if overworld_music == "overworld_2" then
  else
    sol.audio.play_music("overworld_1", function()
      sol.audio.play_music("overworld_2", true)
    end)
  end

 local entrance_names = {
    "main_castle",
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