local map = ...
local game = map:get_game()

local overworld_music = sol.audio.get_music()

function map:on_started()

-- Sets teletransporters invisible
  map:set_entities_enabled("to_puzzle_", false)

-- Sees if entrance puzzle is partially or completely solved when reentering map
  local entrance_puzzle = game:get_value("dungeon_1_f1_entrance_puzzle")
  if entrance_puzzle == 1 then
    map:set_entities_enabled("correct_switch_1_barrier", false)
    map:set_entities_enabled("to_puzzle_2", true)
    correct_switch_1:set_activated(true)
  elseif entrance_puzzle == 2 then
    map:set_entities_enabled("correct_switch_1_barrier", false)
    map:set_entities_enabled("correct_switch_2_barrier", false)
    map:set_entities_enabled("to_puzzle_2", true)
    map:set_entities_enabled("to_puzzle_3", true)
    correct_switch_2:set_activated(true)
  elseif entrance_puzzle == 3 then
    map:set_entities_enabled("correct_switch_1_barrier", false)
    map:set_entities_enabled("correct_switch_2_barrier", false)
    map:set_entities_enabled("correct_switch_3_barrier", false)
    map:set_entities_enabled("to_puzzle_2", true)
    map:set_entities_enabled("to_puzzle_3", true)
    map:set_entities_enabled("to_puzzle_4", true)
    correct_switch_3:set_activated(true)
  elseif entrance_puzzle == 4 then
    map:set_entities_enabled("correct_switch_1_barrier", false)
    map:set_entities_enabled("correct_switch_2_barrier", false)
    map:set_entities_enabled("correct_switch_3_barrier", false)
    map:set_entities_enabled("correct_switch_4_barrier", false)
    map:set_entities_enabled("to_puzzle_2", true)
    map:set_entities_enabled("to_puzzle_3", true)
    map:set_entities_enabled("to_puzzle_4", true)
    map:set_entities_enabled("to_puzzle_5", true)
    correct_switch_4:set_activated(true)
  elseif entrance_puzzle == 5 then
    map:set_entities_enabled("correct_switch_1_barrier", false)
    map:set_entities_enabled("correct_switch_2_barrier", false)
    map:set_entities_enabled("correct_switch_3_barrier", false)
    map:set_entities_enabled("correct_switch_4_barrier", false)
    map:set_entities_enabled("correct_switch_5_barrier", false)
    map:set_entities_enabled("to_puzzle_2", true)
    map:set_entities_enabled("to_puzzle_3", true)
    map:set_entities_enabled("to_puzzle_4", true)
    map:set_entities_enabled("to_puzzle_5", true)
    correct_switch_5:set_activated(true)
    map:set_doors_open("door_a", true)
  end

-- Sets music
  if overworld_music == "castle_2" then
  else
    sol.audio.play_music("castle_1", function()
      sol.audio.play_music("castle_2", true)
    end)
  end
end

function door_b_switch:on_activated()
  map:open_doors("door_b")
  door_b_switch:set_activated(true)
  sol.audio.play_sound("secret")
end

function correct_switch_1:on_activated()
  map:set_entities_enabled("correct_switch_1_barrier", false)
  game:set_value("dungeon_1_f1_entrance_puzzle", 1)
  map:set_entities_enabled("to_puzzle_2", true)
end

function correct_switch_2:on_activated()
  map:set_entities_enabled("correct_switch_2_barrier", false)
  game:set_value("dungeon_1_f1_entrance_puzzle", 2)
  map:set_entities_enabled("to_puzzle_3", true)
end

function correct_switch_3:on_activated()
  map:set_entities_enabled("correct_switch_3_barrier", false)
  game:set_value("dungeon_1_f1_entrance_puzzle", 3)
  map:set_entities_enabled("to_puzzle_4", true)
end

function correct_switch_4:on_activated()
  map:set_entities_enabled("correct_switch_4_barrier", false)
  game:set_value("dungeon_1_f1_entrance_puzzle", 4)
  map:set_entities_enabled("to_puzzle_5", true)
end

function correct_switch_5:on_activated()
  map:set_entities_enabled("correct_switch_5_barrier", false)
  game:set_value("dungeon_1_f1_entrance_puzzle", 5)
  map:open_doors("door_a")
  sol.audio.play_sound("secret")
end