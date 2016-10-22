local map = ...
local game = map:get_game()

local switch_activated = game:get_value("dungeon_1_switch_right")
local big_chest_switch_activated = game:get_value("big_chest_stairs_switch")

function map:on_started()
  if switch_activated == true then
    switch_right:set_activated(true)
    key_chest:set_enabled(true)
  else
    key_chest:set_enabled(false)
  end
  if big_chest_switch_activated == true then
    big_chest_stairs_switch:set_activated(true)
    map:set_entities_enabled("big_chest_stairs", true)
    map:set_entities_enabled("big_chest_railing", false)
  end
  map:set_doors_open("door_1")
  map:set_doors_open("door_2")
  small_key_chest:set_enabled(false)
  dynamic_switch_1:set_enabled(false)
  dynamic_switch_2:set_enabled(false)
end

function sensor_entrance:on_activated_repeat()
  local switch_1 = entrance_switch_1:is_activated()
  local switch_2 = entrance_switch_2:is_activated()
  local switch_3 = entrance_switch_3:is_activated()
  local switch_4 = entrance_switch_4:is_activated()
  local switch_5 = entrance_switch_5:is_activated()
  local switch_6 = entrance_switch_6:is_activated()
  
  if switch_1 == true then
    if switch_2 == true then
      if switch_3 == true then
        if switch_4 == true then
          if switch_5 == true then
            if switch_6 == true then
              map:open_doors("door_entrance")
              sol.audio.play_sound("secret")
              sensor_entrance:set_enabled(false)
            end
          end
        end
      end
    end
  end
end

function sensor_1:on_activated()
  if door_1:is_open() then
    map:close_doors("door_1")
    self:set_enabled(false)
  end
end

function switch_wrong:on_activated()
  sol.audio.play_sound("wrong")
end

function switch_right:on_activated()
  sol.audio.play_sound("chest_appears")
  key_chest:set_enabled(true)
  game:set_value("dungeon_1_switch_right", true)
end

function sensor_enemy_clear:on_activated_repeat()
  local room_full = map:has_entities("auto_enemy_room")
  if door_1_a:is_open() and room_full == true then
    map:close_doors("door_1")    
  elseif room_full == false then
    map:open_doors("door_1")
    sol.audio.play_sound("secret")
    sensor_enemy_clear:set_enabled(false)
  end
end

function door_2_sensor:on_activated()
  map:close_doors("door_2")
end

function sensor_second_enemy_room:on_activated_repeat()
  local room_full = map:has_entities("auto_second_enemy_room")
  if room_full == false then
    dynamic_switch_1:set_enabled(true)
    sol.audio.play_sound("secret")
    sensor_second_enemy_room:set_enabled(false)
  end  
end

function dynamic_switch_1:on_activated()
  sol.audio.play_sound("secret")
  block:set_enabled(false)
  block_2:set_enabled(false)
  block_3:set_enabled(false)
  block_4:set_enabled(false)
  block_5:set_enabled(false)
  block_6:set_enabled(false)
  block_7:set_enabled(false)
  dynamic_switch_2:set_enabled(true)
end

function dynamic_switch_2:on_activated()
  small_key_chest:set_enabled(true)
  sol.audio.play_sound("chest_appears")
end

function big_chest_stairs_switch:on_activated()
  sol.audio.play_sound("secret")
  map:set_entities_enabled("big_chest_stairs", true)
  map:set_entities_enabled("big_chest_railing", false)
  game:set_value("big_chest_stairs_switch", true)
end