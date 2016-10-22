local map = ...
local game = map:get_game()

local overworld_music = sol.audio.get_music()

function map:on_started(destination)
  if overworld_music == "kakariko_village_2" then
  else
    sol.audio.play_music("kakariko_village_1", function()
      sol.audio.play_music("kakariko_village_2", true)
    end)
  end

--Opens doors when hero walks towards them

 local entrance_names = {
    "storage_house", "shop", "mary_house"
  }                               
  for _, entrance_name in ipairs(entrance_names) do
    local sensor = map:get_entity(entrance_name .. "_door_sensor")
    local tile = map:get_entity(entrance_name .. "_door")

    sensor.on_activated_repeat = function()
      if hero:get_direction() == 1
        and tile:is_enabled() then
        tile:set_enabled(false)
        sol.audio.play_sound("door_open")
      end
    end
  end
end

function ben_mailbox:on_interaction()
  game:start_dialog("C1.Mailboxes.Ben", question_finished)
end

function jerry_mailbox:on_interaction()
  game:start_dialog("C1.Mailboxes.Jerry", question_finished)
end

function question_finished(answer)
--Player chooses "Yes"
  if answer == 1 then
  else
    game:start_dialog("C1.Mailboxes.Not_polite")
  end
end