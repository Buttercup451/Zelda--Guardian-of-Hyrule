local map = ...
local game = map:get_game()

function ben_interaction_spot:on_interaction()
  Ben:get_sprite():set_direction(3)
  ben_talk()
end

function ben_interaction_spot_2:on_interaction()
  ben_talk()
end

local function apple_argument()
  return game:get_value("apple_argument_solved")
end

function map:on_started()
  apple_argument()
  if not apple_argument() then
    Ben:remove()
    Pot:remove()
    Pot_2:remove()
    Pot_3:remove()
    Pot_4:remove()
    ben_interaction_spot:remove()
    ben_interaction_spot_2:remove()
  end
  sol.audio.set_music_volume(50)
end

function ben_talk()
  game:start_dialog("_village._ben_house.working", function()
    Ben:get_sprite():set_direction(0)
  end)
end

function Ben:on_interaction()
  ben_talk()
end