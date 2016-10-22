local map = ...
local game = map:get_game()

local total_time = 0
local race_started = false
local overworld_music = sol.audio.get_music()

function map:on_started()
  if overworld_music == "overworld_2" then
  else
    sol.audio.play_music("overworld_1", function()
      sol.audio.play_music("overworld_2", true)
    end)
  end
--Opens doors when hero walks towards them

 local entrance_names = {
    "race_house", "race_house_2", "chest_house"
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

function race_start:on_interaction()
  if race_started == false then
    game:start_dialog("D1.race.1", question_finished)
  else
    game:start_dialog("D1.race.7")
  end
end

function question_finished(answer)
  --Player does not want to play the game
  if answer == 1 then
    game:start_dialog("D1.race.3")
  else
  --Player wants to play the game
    game:start_dialog("D1.race.4", function()
      map:set_entities_enabled("start_gate", false)
      map:set_entities_enabled("gate", true)
      sol.audio.play_sound("switch")
      sol.audio.play_music("mini_game", true)
      timer_starts()
      race_started = true
    end)
  end
end

function timer_starts()
  sol.timer.start(map, 1000, function()
    if total_time == 40 then
      game:start_dialog("D1.race.5", function()
        sol.audio.play_sound("switch")
        map:set_entities_enabled("auto_block", false)
      end)
      sol.audio.play_music("overworld_2", true)
    elseif total_time >= 36 then
      sol.audio.play_sound("timer_hurry")
      total_time = total_time + 1
      timer_starts()
    elseif total_time <= 35 then
      sol.audio.play_sound("timer")
      total_time = total_time + 1
      timer_starts()
    end
  end)
end

function gate_sensor:on_activated()
  map:set_entities_enabled("start_gate", true)
  map:set_entities_enabled("gate", false)
  self:set_enabled(false)
  sol.audio.play_sound("switch")
end

function finish_line:on_activated()
  sol.timer.stop_all(map)
  sol.audio.play_music("overworld_2", true)
  race_started = false
  if total_time <= 39 then
    game:start_dialog("D1.race.8", total_time, player_pass)
  elseif total_time >= 40 then
    game:start_dialog("D1.race.10", player_not_pass)
  end
  self:set_enabled(false)
end

function player_pass()
  game:start_dialog("D1.race.9")
  map:set_entities_enabled("finish_gate", false)
  sol.audio.play_sound("switch")
end

function race_finish:on_interaction()
  finish_line:on_activated()
end