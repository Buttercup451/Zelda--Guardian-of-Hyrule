local map = ...
local game = map:get_game()

function map:on_started()
  sol.audio.set_music_volume(50)
end