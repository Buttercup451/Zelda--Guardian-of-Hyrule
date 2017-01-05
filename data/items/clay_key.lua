local item = ...

function item:on_created()

  self:set_savegame_variable("i1116")
  self:set_assignable(true)
end

function item:on_using()
  local bunny_form = item:get_game():get_value("bunny")
  if bunny_form == false or bunny_form == nil then
    local hero = item:get_map():get_entity("hero")
    tunic_variant = item:get_game():get_ability("tunic")
    hero:set_tunic_sprite_id("hero/tunic4")
    --hero:teleport("Test")
    hero:set_invincible(true)
    item:get_game():set_value("bunny", true)
    disable_abilities()
    self:set_finished()
  elseif bunny_form == true then
    local hero = item:get_map():get_entity("hero")
    if tunic_variant == 1 then
      hero:set_tunic_sprite_id("hero/tunic1")
    elseif tunic_variant == 2 then
      hero:set_tunic_sprite_id("hero/tunic2")
    elseif tunic_variant == 3 then
      hero:set_tunic_sprite_id("hero/tunic1")
    end
   -- hero:teleport("Test")
    hero:set_invincible(false)
    item:get_game():set_value("bunny", false)
    enable_abilities() 
    self:set_finished()
  end
end

function disable_abilities() -- Prevents player from using abilities when in bunny form
  game = item:get_game()
  sword_variant = game:get_ability("sword")
  shield_variant = game:get_ability("shield")
  swim_variant = game:get_ability("swim")
  run_variant = game:get_ability("run")
  game:set_ability("sword", 0)
  game:set_ability("shield", 0)
  game:set_ability("swim", 0)
  game:set_ability("run", 0)
end

function enable_abilities() -- Gives player their abilities back
  game = item:get_game()
  game:set_ability("sword", sword_variant)
  game:set_ability("shield", shield_variant)
  game:set_ability("swim", swim_variant)
  game:set_ability("run", run_variant)
end