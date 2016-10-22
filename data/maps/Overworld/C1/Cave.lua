local map = ...
local game = map:get_game()

local switch_activated = game:get_value("c1_cave_switch")
local door_opened = game:get_value("c1_cave_door")

function map:on_started()
  if switch_activated == nil then
    map:set_entities_enabled("pot_shot", false)
  elseif switch_activated == 1 then
    pot_switch:set_activated(true)
  end
  if door_opened == true then
    map:set_entities_enabled("door_open", true)
  end
end

function hero_lands_sensor:on_activated()
  sol.audio.play_sound("hero_lands")
  self:set_enabled(false)
end

function pot_switch:on_activated()
  map:set_entities_enabled("pot_shot", true)
  game:set_value("c1_cave_switch", 1)
  sol.audio.play_sound("secret")
end

function door_a:on_opened()
  map:set_entities_enabled("door_open", true)
end