local map = ...
local game = map:get_game()

local overworld_music = sol.audio.get_music()

function map:on_started()
  if overworld_music == "cave_2" then
  else
    sol.audio.play_music("cave_1", function()
      sol.audio.play_music("cave_2", true)
    end)
  end
end

function switch_1:on_activated()
  local switch_one = switch_1:is_activated()
  local switch_two = switch_2:is_activated()
  local switch_three = switch_3:is_activated()
  local switch_four = switch_4:is_activated()
  if switch_two == true then
    if switch_three == true then
      if switch_four == true then
        map:open_doors("door_1")
        sol.audio.play_sound("secret")
      end
    end
  end
end

function switch_2:on_activated()
  local switch_one = switch_1:is_activated()
  local switch_two = switch_2:is_activated()
  local switch_three = switch_3:is_activated()
  local switch_four = switch_4:is_activated()
  if switch_one == true then
    if switch_three == true then
      if switch_four == true then
        map:open_doors("door_1")
        sol.audio.play_sound("secret")
      end
    end
  end
end

function switch_3:on_activated()
  local switch_one = switch_1:is_activated()
  local switch_two = switch_2:is_activated()
  local switch_three = switch_3:is_activated()
  local switch_four = switch_4:is_activated()
  if switch_two == true then
    if switch_one == true then
      if switch_four == true then
        map:open_doors("door_1")
        sol.audio.play_sound("secret")
      end
    end
  end
end

function switch_4:on_activated()
  local switch_one = switch_1:is_activated()
  local switch_two = switch_2:is_activated()
  local switch_three = switch_3:is_activated()
  local switch_four = switch_4:is_activated()
  if switch_two == true then
    if switch_three == true then
      if switch_one == true then
        map:open_doors("door_1")
        sol.audio.play_sound("secret")
      end
    end
  end
end