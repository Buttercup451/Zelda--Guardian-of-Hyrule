local map = ...
local game = map:get_game()

local overworld_music = sol.audio.get_music()

function map:on_started(destination)
  if overworld_music == "Frozen Hyrule 2" then
  else
    sol.audio.play_music("Frozen Hyrule 1", function()
      sol.audio.play_music("Frozen Hyrule 2", true)
    end)
  end
  map:display_fog("snow", 30, 5, 255)
end