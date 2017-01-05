-- Title screen of the game.

local title_screen = {}

function title_screen:on_started()

  -- black screen during 0.3 seconds
  self.phase = "black"

  self.surface = sol.surface.create(320, 240)
  sol.timer.start(self, 300, function()
    self:phase_zs_presents()
  end)

  -- use these 0.3 seconds to preload all sound effects
  sol.audio.preload_sounds()
end

function title_screen:phase_zs_presents()

  -- "Zelda Solarus presents" displayed for two seconds
  self.phase = "zs_presents"

  self.zs_presents_img =
      sol.surface.create("title_screen_initialization.png", true)

  local width, height = self.zs_presents_img:get_size()
  self.zs_presents_pos = { 160 - width / 2, 120 - height / 2 }
  sol.audio.play_sound("intro")

  sol.timer.start(self, 2000, function()
    self.surface:fade_out(10)
    sol.timer.start(self, 700, function()
      self:phase_title()
    end)
  end)
end

function title_screen:phase_title()

  -- actual title screen
  self.phase = "title"

  -- start music
  sol.audio.play_music("title_music")
  sol.timer.start(self, 6036, function()
    sol.audio.play_music("opening")
    sol.timer.start(self, 81536, function()
      sol.audio.stop_music()
    end)
  end)

  -- create all images
  self.water_img = sol.surface.create("menus/title_water.png")
  self.clouds_2 = sol.surface.create("menus/title_clouds_bottom_layer2.png")
  self.clouds_4 = sol.surface.create("menus/title_clouds_top_layer2.png")
  self.lightning_1 = sol.surface.create("menus/lightning_1.png")
  self.clouds_1 = sol.surface.create("menus/title_clouds_bottom_layer1.png")
  self.clouds_3 = sol.surface.create("menus/title_clouds_top_layer1.png")
  self.logo_img = sol.surface.create("menus/title_logo.png")
  self.borders_img = sol.surface.create("menus/title_borders.png")

  local dialog_font, dialog_font_size = sol.language.get_dialog_font()
  local menu_font, menu_font_size = sol.language.get_menu_font()

  self.press_space_img = sol.text_surface.create{
    font = dialog_font,
    font_size = dialog_font_size,
    color = {255, 255, 255},
    text_key = "title_screen.press_space",
    horizontal_alignment = "center"
  }

  -- set up the appearance of images and texts
 
  
  sol.timer.start(self, 5000, function()
    sol.audio.play_sound("ok")
    self.dx_img = sol.surface.create("menus/title_dx.png")
  end)

  sol.timer.start(self, 6000, function()
    self.star_img = sol.surface.create("menus/title_star.png")
  end)

  self.show_press_space = false
  function switch_press_space()
    self.show_press_space = not self.show_press_space
    sol.timer.start(self, 500, switch_press_space)
  end
  sol.timer.start(self, 6500, switch_press_space)

  -- make clouds move
  self.clouds_xy = {x = 320, y = 300}
  self.clouds_bottom_back_xy = {x = 320, y = 300}
  self.clouds_top_front_xy = {x = 0, y = 15}
  self.clouds_top_back_xy = {x = 0, y = 0}
  self.water_xy = {x = 320, y = 240}
  function move_clouds()
    -- make clouds_1 move
    self.clouds_xy.x = self.clouds_xy.x + 1
    if self.clouds_xy.x >= 535 then
      self.clouds_xy.x = self.clouds_xy.x - 535
    end
 
    -- make clouds_2 move
    self.clouds_bottom_back_xy.x = self.clouds_bottom_back_xy.x - 1
    if self.clouds_bottom_back_xy.x <= -215 then
      self.clouds_bottom_back_xy.x = self.clouds_bottom_back_xy.x + 535
    end

    -- make clouds_3 move 
    self.clouds_top_front_xy.x = self.clouds_top_front_xy.x - 1
    if self.clouds_top_front_xy.x <= -215 then
      self.clouds_top_front_xy.x = self.clouds_top_front_xy.x + 535
    end

    -- make clouds_4 move 
    self.clouds_top_back_xy.x = self.clouds_top_back_xy.x + 1
    if self.clouds_top_back_xy.x >= 535 then
      self.clouds_top_back_xy.x = self.clouds_top_back_xy.x - 535
    end
    sol.timer.start(self, 50, move_clouds)
  end
  sol.timer.start(self, 50, move_clouds)

  function move_water()
    self.water_xy.x = self.water_xy.x + 1
    self.water_xy.y = self.water_xy.y - 1
    if self.water_xy.x >= 535 then
      self.water_xy.x = self.water_xy.x - 535
    end
    if self.water_xy.y < 0 then
      self.water_xy.y = self.water_xy.y + 299
    end
  sol.timer.start(self, 50, move_water)
  end
  sol.timer.start(self, 50, move_water)

  -- show an opening transition
  self.surface:fade_in(30)

  self.allow_skip = false
  sol.timer.start(self, 6036, function()
    self.allow_skip = true
  end)
end

function title_screen:on_draw(dst_surface)

  if self.phase == "title" then
    self:draw_phase_title(dst_surface)
  elseif self.phase == "zs_presents" then
    self:draw_phase_present()
  end

  -- final blit (dst_surface may be larger)
  local width, height = dst_surface:get_size()
  self.surface:draw(dst_surface, width / 2 - 160, height / 2 - 120)
end

function title_screen:draw_phase_present()

  self.zs_presents_img:draw(self.surface, self.zs_presents_pos[1], self.zs_presents_pos[2])
end

function title_screen:draw_phase_title()

  -- background
  self.surface:fill_color({63, 107, 189})

  -- move water
  local x, y = self.water_xy.x, self.water_xy.y
  self.water_img:draw(self.surface, x, y)
  x = self.water_xy.x - 535
  self.water_img:draw(self.surface, x, y)
  x = self.water_xy.x
  y = self.water_xy.y - 299
  self.water_img:draw(self.surface, x, y)
  x = self.water_xy.x - 535
  y = self.water_xy.y - 299
  self.water_img:draw(self.surface, x, y)

  -- clouds
  local x, y = self.clouds_xy.x, self.clouds_xy.y
  self.clouds_1:draw(self.surface, x, y)
  x = self.clouds_xy.x - 535
  self.clouds_1:draw(self.surface, x, y)
  x = self.clouds_xy.x
  y = self.clouds_xy.y - 299
  self.clouds_1:draw(self.surface, x, y)
  x = self.clouds_xy.x - 535
  y = self.clouds_xy.y - 299
  self.clouds_1:draw(self.surface, x, y)

  local x_three, y_three = self.clouds_top_front_xy.x, self.clouds_top_front_xy.y
  self.clouds_3:draw(self.surface, x_three, y_three)
  x_three = self.clouds_top_front_xy.x - 535
  self.clouds_3:draw(self.surface, x_three, y_three)
  x_three = self.clouds_top_front_xy.x
  y_three = self.clouds_top_front_xy.y - 299
  self.clouds_3:draw(self.surface, x_three, y_three)
  x_three = self.clouds_top_front_xy.x - 535
  y_three = self.clouds_top_front_xy.y - 299
  self.clouds_3:draw(self.surface, x_three, y_three)

  local x_two, y_two = self.clouds_bottom_back_xy.x, self.clouds_bottom_back_xy.y
  self.clouds_2:draw(self.surface, x_two, y_two)
  x_two = self.clouds_bottom_back_xy.x - 535
  self.clouds_2:draw(self.surface, x_two, y_two)
  x_two = self.clouds_bottom_back_xy.x
  y_two = self.clouds_bottom_back_xy.y - 299
  self.clouds_2:draw(self.surface, x_two, y_two)
  x_two = self.clouds_bottom_back_xy.x - 535
  y_two = self.clouds_bottom_back_xy.y - 299
  self.clouds_2:draw(self.surface, x_two, y_two)

  local x_four, y_four = self.clouds_top_back_xy.x, self.clouds_top_back_xy.y
  self.clouds_4:draw(self.surface, x_four, y_four)
  x_four = self.clouds_top_back_xy.x - 535
  self.clouds_4:draw(self.surface, x_four, y_four)
  x_four = self.clouds_top_back_xy.x
  y_four = self.clouds_top_back_xy.y - 299
  self.clouds_4:draw(self.surface, x_four, y_four)
  x_four = self.clouds_top_back_xy.x - 535
  y_four = self.clouds_top_back_xy.y - 299
  self.clouds_4:draw(self.surface, x_four, y_four)



  -- black bars
  self.borders_img:draw(self.surface, 0, 0)

  -- website name and logo
  self.logo_img:draw(self.surface)

  if self.dx_img then
    self.dx_img:draw(self.surface)
  end
  if self.star_img then
    self.star_img:draw(self.surface)
  end
  if self.show_press_space then
    self.press_space_img:draw(self.surface, 160, 200)
  end
  
end

function title_screen:on_key_pressed(key)

  local handled = false

  if key == "escape" then
    -- stop the program
    sol.main.exit()
    handled = true

  elseif key == "space" or key == "return" then
    handled = self:try_finish_title()

--  Debug.
  elseif sol.main.is_debug_enabled() then
    if key == "left shift" or key == "right shift" then
      self:finish_title()
      handled = true
    end
  end
end

function title_screen:on_joypad_button_pressed(button)

  return self:try_finish_title()
end

-- Ends the title screen (if possible)
-- and starts the savegame selection screen
function title_screen:try_finish_title()

  local handled = false

  if self.phase == "title"
      and self.allow_skip
      and not self.finished then
    self.finished = true

    self.surface:fade_out(30)
    sol.audio.play_sound("ok")
    sol.timer.start(self, 700, function()
      self:finish_title()
    end)

    handled = true
  end

  return handled
end

function title_screen:finish_title()

  sol.audio.stop_music()
  sol.menu.stop(self)
end

return title_screen

