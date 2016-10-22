local map = ...
local game = map:get_game()

local solved = game:get_value("c1_shop_block_solved")
local overworld_music = sol.audio.get_music()

function map:on_started()
  if overworld_music == "house_2" then
  else
    sol.audio.play_music("house_1", function()
      sol.audio.play_music("house_2", true)
    end)
  end
  if solved == 1 then
    map:set_entities_enabled("block_unsolved", false)
  else
    map:set_entities_enabled("block_solved", false)
  end
end

function block_unsolved:on_moved()
  game:set_value("c1_shop_block_solved", 1)
end