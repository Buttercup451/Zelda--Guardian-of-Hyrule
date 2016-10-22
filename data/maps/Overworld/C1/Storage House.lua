local map = ...
local game = map:get_game()

local hole_open = door_hole:is_open()
local overworld_music = sol.audio.get_music()

function map:on_started()
  if overworld_music == "house_2" then
  else
    sol.audio.play_music("house_1", function()
      sol.audio.play_music("house_2", true)
    end)
  end
  if hole_open == true then
    map:set_entities_enabled("hole_", true)
    map:set_entities_enabled("weak_floor", false)
  else  
    map:set_entities_enabled("hole_", false)
  end
end

function door_hole:on_opened()
  map:set_entities_enabled("hole_", true)
  sol.audio.play_sound("secret")
end