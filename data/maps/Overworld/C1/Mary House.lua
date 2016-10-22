local map = ...
local game = map:get_game()

local overworld_music = sol.audio.get_music()

function map:on_started()
  if overworld_music == "house_2" then
  else
    sol.audio.play_music("house_1", function()
      sol.audio.play_music("house_2", true)
    end)
  end
end