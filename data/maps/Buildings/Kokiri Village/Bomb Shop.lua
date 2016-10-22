local map = ...
local game = map:get_game()

function map:on_started()
  sol.audio.set_music_volume(50)
end

function door_a:on_opened()
  sol.timer.start(1000, function()
    game:start_dialog("_village._bomb_shop.explosion", pay_damages)
  end)
  sol.audio.play_sound("secret")
end

function pay_damages()
  local how_much = game:get_money()
  if how_much >= 2 then
    game:start_dialog("_village._bomb_shop.damages", how_much, function()
      game:remove_money(how_much)
      game:start_dialog("_village._bomb_shop.scorn", game:get_player_name(), function()
        how_much = 0
      end)
    end)
  elseif how_much == 1 then
    game:start_dialog("_village._bomb_shop.damages_single_rupee", how_much, function()
      game:remove_money(how_much)
      game:start_dialog("_village._bomb_shop.scorn", game:get_player_name(), function()
        how_much = 0
      end)
    end)
  else
    game:start_dialog("_vilage._bomb_shop.no_rupees")
  end
end