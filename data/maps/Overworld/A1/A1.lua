local map = ...
local game = map:get_game()

function map:on_started(destination)
  map:display_fog("alttpfog", 25, 4, 64)
end

function secret_bush:on_cut()
  sol.audio.play_sound("secret")
end

function secret_bush:on_lifting()
  sol.audio.play_sound("secret")
end