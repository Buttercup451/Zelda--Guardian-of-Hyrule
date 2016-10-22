local map = ...
local game = map:get_game()
local light_manager = require("maps/lib/light_manager")
local overworld_music = sol.audio.get_music()

function map:on_started()
-- Enables light manager script
  light_manager.enable_light_features(map)
  map:set_light(0)

-- Sets music
  if overworld_music == "castle_2" then
  else
    sol.audio.play_music("castle_1", function()
      sol.audio.play_music("castle_2", true)
    end)
  end
end

function hint:on_interaction()
  game:start_dialog("Dungeons.Hyrule Castle.F1.Hint", game:get_player_name())
end

function riddle_5:on_interaction()
  game:start_dialog("Dungeons.Hyrule Castle.F1.Riddle_5")
end

function riddle:on_interaction()
  game:start_dialog("Dungeons.Hyrule Castle.F1.Riddle_1")
end

function riddle_2:on_interaction()
  game:start_dialog("Dungeons.Hyrule Castle.F1.Riddle_2")
end

function riddle_3:on_interaction()
  game:start_dialog("Dungeons.Hyrule Castle.F1.Riddle_3")
end

function riddle_4:on_interaction()
  game:start_dialog("Dungeons.Hyrule Castle.F1.Riddle_4")
end

function riddle_6:on_interaction()
  game:start_dialog("Dungeons.Hyrule Castle.F1.Riddle_6")
end