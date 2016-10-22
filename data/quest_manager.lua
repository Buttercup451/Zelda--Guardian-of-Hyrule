-- This script handles global behavior of this quest,
-- that is, things not related to a particular savegame.
local quest_manager = {}

--Map Metatable
local map_metatable = sol.main.get_metatable("map")
function map_metatable:add_overlay(image_file_name)
  -- Here, self is the map.
  self.overlay = sol.surface.create(image_file_name)
end

function map_metatable:on_draw(dst_surface)
  if self.overlay ~= nil then
    self.overlay:draw(dst_surface)
  end
end

--Enables fog
function map_metatable:display_fog(fog, speed, angle, opacity)
  local fog = fog or nil
  local speed = speed or 1
  local angle = angle or 0
  local opacity = opacity or 16
  if type(fog) == "string" then
    self.fog = sol.surface.create("fogs/"..fog..".png")
    self.fog:set_opacity(opacity)
    self.fog_size_x, self.fog_size_y = self.fog:get_size()
    self.fog_m = sol.movement.create("straight")
  end

  function restart_overlay_movement()
    self.fog_m:set_speed(speed) 
    self.fog_m:set_max_distance(self.fog_size_x / 2)
    self.fog_m:set_angle(angle * math.pi / 4)
    self.fog_m:start(self.fog, function()
      restart_overlay_movement()
      self.fog:set_xy(0,0)
      end)
    end
    restart_overlay_movement()
    self:get_game():set_value("current_fog", fog)
  end
  
  function map_metatable:get_current_fog()
    return self:get_game():get_value("current_fog")
  end
 
  function map_metatable:on_draw(dst_surface)
    local scr_x, scr_y = dst_surface:get_size()
    if self:get_current_fog() ~= nil then
      local camera_x, camera_y = self:get_camera_position()
      local overlay_width, overlay_height = self.fog:get_size()
      local x, y = camera_x, camera_y
      x, y = -math.floor(x), -math.floor(y)
      x = x % overlay_width - 4 * overlay_width
      y = y % overlay_height - 4 * overlay_height
      local dst_y = y
      while dst_y < scr_y + overlay_height do
        local dst_x = x
        while dst_x < scr_x + overlay_width do
          self.fog:draw(dst_surface, dst_x, dst_y)
          dst_x = dst_x + overlay_width
        end
        dst_y = dst_y + overlay_height
      end
    end
end
 
function map_metatable:on_finished()
  self:get_game():set_value("current_fog", nil)
end

--Currently does not work with Fog Script
--[[Enables showing the map name
function map_metatable:show_map_name(map_name, display_extra)
  local map_name = map_name or nil
  local display_extra = display_extra or nil
  if type(map_name) == "string" then
    self.map_name = sol.text_surface.create{
      horizontal_alignment = "center",
      vertical_alignment = "middle",
      font = "map_name", 
      }             
 
    self.boss_presentation_text = sol.text_surface.create{
      horizontal_alignment = "center",
      vertical_alignment = "middle",
      font = "map_name", 
      }             
                  
  if (type(display_extra) == "string" and display_extra ~= "boss_name") or type(display_extra) == "nil" then
    self.map_name:set_text_key("map.gameplay.map_name."..map_name)
    self.mx, self.my = self.map_name:get_size()
    self.map_name_surface = sol.surface.create(self.mx * 2, self.my)
    self.map_name:draw(self.map_name_surface, self.mx, self.my * 0.5)     
    self.map_name_surface:set_opacity(0) 
    self.display_boss_name = false                  
  else
    self.display_boss_name = true               
    local i = 0
    local text_group = sol.language.get_string("map.gameplay.boss_name."..map_name)
    for text_lines in string.gmatch(text_group, "[^$]+") do
      i = i + 1
      if i == 1 then
        self.map_name:set_text(text_lines)
        self.mx, self.my = self.map_name:get_size()
        self.map_name_surface = sol.surface.create(self.mx * 2 , self.my * 4)
        self.map_name:draw(self.map_name_surface, self.mx, self.my * 0.5)
        self.map_name_surface:set_opacity(0) 
      else
        self.boss_presentation_text:set_text(text_lines)
        local tw, th = self.boss_presentation_text:get_size()
        self.boss_presentation_text:draw(self.map_name_surface, self.mx - 7 , (self.my * 0.5) + (i*7))
        if tw > self.mx then
          self.mx = tw
        end
        if th > self.my then
          self.my = th
        end
      end
    end
  end           
                
  sol.timer.start(self, 500, function()
    self.map_name_surface:fade_in(40)
    sol.timer.start(self, 3500, function()
      self.map_name_surface:fade_out(40, function()
        self.map_name_surface:clear()
        self:get_game():set_value("previous_map_name_displayed", nil)
      end)
    end)
  end)
  end
  self:get_game():set_value("previous_map_name_displayed", map_name)
end
  
function map_metatable:get_displaying_map_name()
  return self:get_game():get_value("previous_map_name_displayed")
end
 
function map_metatable:on_draw(dst_surface)
  if self:get_displaying_map_name() ~= nil then
    local map_name_width, map_name_height = self.map_name:get_size()
    if self.display_boss_name then
      self.map_name_surface:draw(dst_surface, (scr_x / 2) - (map_name_width) + 3, (scr_y / 2) + (map_name_height * 4.8))
    else 
      self.map_name_surface:draw(dst_surface, (scr_x / 2) - (map_name_width), (scr_y / 2) - (map_name_height * 3))
    end
  end
end  
 
function map_metatable:on_finished()
  self:get_game():set_value("previous_map_name_displayed", nil)
end--]]

-- Initializes the behavior of destructible entities.
local function initialize_destructibles()

  -- Show a dialog when the player cannot lift them.
  local destructible_meta = sol.main.get_metatable("destructible")
  -- destructible_meta represents the shared behavior of all destructible objects.

  function destructible_meta:on_looked()

    -- Here, self is the destructible object.
    local game = self:get_game()
    if self:get_can_be_cut()
        and not self:get_can_explode()
        and not self:get_game():has_ability("sword") then
      -- The destructible can be cut, but the player has no cut ability.
      game:start_dialog("_cannot_lift_should_cut");
    elseif not game:has_ability("lift") then
      -- No lift ability at all.
      game:start_dialog("_cannot_lift_too_heavy");
    else
      -- Not enough lift ability.
      game:start_dialog("_cannot_lift_still_too_heavy");
    end
  end
end

-- Initializes the behavior of enemies.
local function initialize_enemies()

  -- Enemies: redefine the damage of the hero's sword.
  -- (The default damages are less important.)
  local enemy_meta = sol.main.get_metatable("enemy")

  function enemy_meta:on_hurt_by_sword(hero, enemy_sprite)

    -- Here, self is the enemy.
    local game = self:get_game()
    local sword = game:get_ability("sword")
    local damage_factors = { 1, 2, 4, 8 }  -- Damage factor of each sword.
    local damage_factor = damage_factors[sword]
    if hero:get_state() == "sword spin attack" then
      -- The spin attack is twice more powerful.
      damage_factor = damage_factor * 2
    elseif hero:get_state() == "running" then
      -- Hitting an enemy while running is twice more powerful.
      damage_factor = damage_factor * 2
    end

    local reaction = self:get_attack_consequence_sprite(enemy_sprite, "sword")
    self:remove_life(reaction * damage_factor)
  end
end

-- Initialize sensor behavior specific to this quest.
local function initialize_sensor()

  local sensor_meta = sol.main.get_metatable("sensor")

  function sensor_meta:on_activated()

    local game = self:get_game()
    local hero = self:get_map():get_hero()
    local name = self:get_name()

    -- Sensors named "to_layer_X_sensor" move the hero on that layer.
    -- TODO use a custom entity or a wall to block enemies and thrown items?
    if name:match("^layer_up_sensor") then
      local x, y, layer = hero:get_position()
      if layer < 2 then
        hero:set_position(x, y, layer + 1)
      end
    elseif name:match("^layer_down_sensor") then
      local x, y, layer = hero:get_position()
      if layer > 0 then
        hero:set_position(x, y, layer - 1)
      end
    end

  end
end

-- Initializes map entity related behaviors.
local function initialize_entities()

  initialize_destructibles()
  initialize_enemies()
  initialize_sensor()
end

-- Performs global initializations specific to this quest.
function quest_manager:initialize_quest()

  initialize_entities()
end

return quest_manager

