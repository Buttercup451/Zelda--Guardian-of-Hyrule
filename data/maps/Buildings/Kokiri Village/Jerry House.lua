local map = ...
local game = map:get_game()

function jerry_interaction_spot:on_interaction()
  Jerry:get_sprite():set_direction(3)
  jerry_talk()
end

function jerry_interaction_spot_2:on_interaction()
  jerry_talk()
end

local function apple_argument()
  return game:get_value("apple_argument_solved")
end

function map:on_started()
  apple_argument()
  if not apple_argument() then
    Jerry:remove()
    Pot:remove()
    Pot_2:remove()
    Pot_3:remove()
    Pot_4:remove()
    jerry_interaction_spot:remove()
    jerry_interaction_spot_2:remove()
  end
  sol.audio.set_music_volume(50)
end

function jerry_talk()
  game:start_dialog("_village._jerry_house.working", function()
    Jerry:get_sprite():set_direction(2)
  end)
end

function Jerry:on_interaction()
  jerry_talk()
end