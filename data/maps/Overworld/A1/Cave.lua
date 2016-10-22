local map = ...
local game = map:get_game()

local hole_switch_activated = game:get_value("a1_cave_hole_switch")
local talked_to_thief = game:get_value("a1_cave_puzzle_thief")
local started = game:get_value("tile_read")
local puzzle_solved = game:get_value("a1_cave_piece_of_heart")
local overworld_music = sol.audio.get_music()

function map:on_started()
  if overworld_music == "cave_2" then
  else
    sol.audio.play_music("cave_1", function()
      sol.audio.play_music("cave_2", true)
    end)
  end
  if puzzle_solved == true then
    map:set_entities_enabled("top_floor_hint_stone", false)
  end
  if hole_switch_activated == true then
    map:set_entities_enabled("hole_part", true)
    hole_switch:set_activated(true)
  else
    map:set_entities_enabled("hole_part", false)
  end
  if started == true then
    map:set_entities_enabled("puzzle_hole", true)
  else
    map:set_entities_enabled("puzzle_hole", false)
  end
end

function top_floor_hint_stone:on_interaction()
  game:start_dialog("A1.cave.top_floor_help", game:get_player_name())
end

function puzzle_start:on_interaction()
  game:start_dialog("A1.cave.top_floor_help_2", function()
    if started == nil then
      map:set_entities_enabled("puzzle_hole", true)
      sol.audio.play_sound("switch")
      game:set_value("tile_read", true)
    end
  end)
end

function hero_fall_sensor:on_activated()
  sol.audio.play_sound("hero_lands")
  self:set_enabled(false)
end

function hole_switch:on_activated()
  sol.audio.play_sound("secret")
  map:set_entities_enabled("hole_part", true)
  game:set_value("a1_cave_hole_switch", true)
end

function thief:on_interaction()
  if talked_to_thief == true then
    game:start_dialog("A1.cave.thief_talked_to", function()
      thief:get_sprite():set_direction(3)
    end)
  elseif talked_to_thief == nil then
    game:start_dialog("A1.cave.thief", function()
      thief:get_sprite():set_direction(3)
      game:set_value("a1_cave_puzzle_thief", true)
    end)
  end
end