local map = ...
local game = map:get_game()

local function jump_from_bed()
  hero:set_visible(true)
  hero:start_jumping(4, 24, true)
  bed:get_sprite():set_animation("empty_open")
  sol.audio.play_sound("hero_lands")
  sol.timer.start(1000, function()
    hero:freeze()
    game:start_dialog("intro.mary_exit", game:get_player_name(), function()
      local movement = sol.movement.create("path")
      movement:set_ignore_obstacles(true)
      movement:set_path{4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6}
      movement:set_speed(80)
      movement:start(Mary)
      sol.timer.start(3500, function()
        Mary:remove()
        game:set_hud_enabled(true)
        game:set_pause_allowed(true)
        hero:unfreeze()
      end)
    end)
  end)
end

local function wake_up()
  snores:remove()
  bed:get_sprite():set_animation("hero_waking")
  sol.timer.start(500, jump_from_bed)
end

function map:on_started(destination)
  sol.audio.set_music_volume(50)
  if destination == from_intro then
    -- the intro scene is playing
    game:set_hud_enabled(false)
    game:set_pause_allowed(false)
    game:set_dialog_style("box")
    snores:get_sprite():set_ignore_suspend(true)
    bed:get_sprite():set_animation("hero_sleeping")
    hero:freeze()
    hero:set_visible(false)
    sol.timer.start(2000, function()
      game:start_dialog("intro.wake_up", game:get_player_name(), function()
        sol.timer.start(3500, move_mary)
      end)
    end)
  else
    Mary:remove()
    snores:remove()
  end
end



function move_mary()
  game:start_dialog("intro.wake_up2", game:get_player_name(), function()
    local movement = sol.movement.create("path")
    movement:set_ignore_obstacles(true)
    movement:set_path{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0}
    movement:set_speed(80)
    movement:start(Mary)
    sol.timer.start(3500, function()
      game:start_dialog("intro.sleepy_head")
    end)
    sol.timer.start(5500, function()
      game:start_dialog("intro.present", wake_up)
    end)
  end)
end