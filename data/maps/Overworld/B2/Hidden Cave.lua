local map = ...
local game = map:get_game()

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