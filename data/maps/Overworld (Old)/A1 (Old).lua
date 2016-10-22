local map = ...
local game = map:get_game()

function map:on_started()
-- Checks to see if the apple argument is already solved
  if game:get_value("apple_argument_solved") == true then
    NPC6:remove()
    NPC7:remove()
  else
    game:set_value("apple_argument_chest", 1)
  end
-- Sets correct music for each section of the map
  sol.audio.set_music_volume(100)
  local hero_x, hero_y = hero:get_position()
  if hero_x <= 640 then
    if hero_y >= 680 then
      sol.audio.play_music("Kokiri Village")
    end
  end
-- Move the NPCs
  npc1_movement()
  npc2_movement()
  npc3_movement()
  npc4_movement()
-- Open doors when hero walks towards them
  local entrance_names = {
    "link_house", "bomb_shop", "library", "blue_house", "ben_house", "jerry_house"
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

function separator_village:on_activating()
  local direction = hero:get_direction()
  if direction == 2 then
    sol.audio.stop_music()
    sol.audio.play_music("Kokiri Village")
  elseif direction == 0 then
    sol.audio.stop_music()
    sol.audio.play_music("Kokiri Forest")
  end
end

function separator_village_2:on_activating()
  local direction = hero:get_direction()
  if direction == 2 then
    sol.audio.stop_music()
    sol.audio.play_music("Kokiri Village")
  elseif direction == 0 then
    sol.audio.stop_music()
    sol.audio.play_music("Kokiri Forest")
  end
end

function bomb_shop_secret_door:on_opened()
  sol.audio.play_sound("secret")
end

function npc1_movement()
  local movement = sol.movement.create("random")
  movement:set_speed(30)
  movement:start(NPC1)
end

function npc2_movement()
  local movement = sol.movement.create("random")
  movement:set_speed(30)
  movement:start(NPC2)
end

function npc3_movement()
  local movement = sol.movement.create("random")
  movement:set_speed(30)
  movement:start(NPC3)
end

function npc4_movement()
  local movement = sol.movement.create("random")
  movement:set_speed(30)
  movement:start(NPC4)
end

local function hero_direction()
  return hero:get_direction()
end

function NPC6:on_interaction()
  NPC6:get_sprite():set_direction(0)
  if hero_direction() == 1 then
    argument_start()
  end
end

function argument_start()
  hero:freeze()
  game:start_dialog("_village.npcs.apple_argument", function()
    NPC6:get_sprite():set_direction(3)
    NPC7:get_sprite():set_direction(3)
    game:start_dialog("_village.npcs.apple_argument2", game:get_player_name(), function()
      NPC6:get_sprite():set_direction(0)
      NPC7:get_sprite():set_direction(2)
      game:start_dialog("_village.npcs.apple_argument3", function()
        NPC6:get_sprite():set_direction(3)
        game:start_dialog("_village.npcs.apple_argument4", game:get_player_name(), function()
          sol.timer.start(1000, apple_argument)
        end)
      end)
    end)
  end)
end

function NPC7:on_interaction()
  NPC7:get_sprite():set_direction(2)
  if hero_direction() == 1 then
    argument_start()
  end
end

function apple_argument()
  if game:get_item("apples_counter"):has_amount(1) then
    game:get_item("apples_counter"):remove_amount(1)
    NPC6:get_sprite():set_direction(0)
    game:set_value("apple_argument_solved", true)
    game:set_value("apple_argument_chest", 0)
    game:start_dialog("_village.npcs.apple_argument_resolved", game:get_player_name(), move_ben_and_jerry)
  else
    sol.timer.start(1000, function()
      game:start_dialog("_village.npcs.apple_argument_not_resolved", game:get_player_name(), function()
        NPC6:get_sprite():set_direction(0)
      end)
    end)
  end
  hero:unfreeze()
end

function secret_bush:on_lifting()
  sol.audio.play_sound("secret")
end

function move_ben_and_jerry()
  move_ben()
  move_jerry()
end

function move_ben()
  local movement = sol.movement.create("path")
  movement:set_speed(80)
  movement:set_path{4, 4, 4, 4, 4}
  movement:start(NPC6)
  sol.timer.start(500, function()
    move_ben_2()
  end)
end

function move_ben_2()
  ben_house_door:set_enabled(false)
  sol.audio.play_sound("door_open")
  local movement = sol.movement.create("path")
  movement:set_speed(80)
  movement:set_path{2, 2}
  movement:start(NPC6)
  sol.timer.start(250, function()
    move_ben_3()
  end)
end

function move_ben_3()
  NPC6:remove()
  ben_house_door:set_enabled(true)
  sol.audio.play_sound("door_closed")
end

function move_jerry()
  local movement = sol.movement.create("path")
  movement:set_speed(80)
  movement:set_path{0, 0, 0, 0, 0}
  movement:start(NPC7)
  sol.timer.start(500, function()
    move_jerry_2()
  end)
end

function move_jerry_2()
  jerry_house_door:set_enabled(false)
  sol.audio.play_sound("door_open")
  local movement = sol.movement.create("path")
  movement:set_speed(80)
  movement:set_path{2, 2}
  movement:start(NPC7)
  sol.timer.start(250, function()
    move_jerry_3()
  end)
end

function move_jerry_3()
  NPC7:remove()
  jerry_house_door:set_enabled(true)
  sol.audio.play_sound("door_closed")
end