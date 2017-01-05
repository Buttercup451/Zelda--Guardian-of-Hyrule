local map = ...
local game = map:get_game()

local overworld_music = sol.audio.get_music()

function map:on_started()
  if overworld_music == "Cave_1" then
  else
    sol.audio.play_music("Cave_1", function()
      sol.audio.play_music("Cave_2", true)
    end)
  end
  map:set_entities_enabled("great_fairy", false)
  map:set_entities_enabled("fairy_shadow", false)
end

function fairy_sensor:on_activated()
  sol.audio.stop_music()
  sol.audio.play_music("great_fairy")
  hero:freeze()
  map:set_entities_enabled("great_fairy", true)
  map:set_entities_enabled("fairy_shadow", true)
  fairy_shadow:get_sprite():set_animation("big")
  great_fairy:get_sprite():set_animation("fade", function()
    great_fairy:get_sprite():set_animation("stopped", start_dialog())
  end)
end

function start_dialog()
  game:start_dialog("A2.cave.great_fairy", function()
    game:add_life(20 * 4)
    great_fairy:get_sprite():set_animation("fade_out", function()
      map:set_entities_enabled("great_fairy", false)
      map:set_entities_enabled("fairy_shadow", false)
      map:set_entities_enabled("fairy_sensor", false)
      hero:unfreeze()
    end)
  end)
end