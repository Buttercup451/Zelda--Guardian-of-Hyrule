local map = ...
local game = map:get_game()

-- Initialize game
local playing_game = false
local game_played = false
local chests_opened = 0
local number = 0
local chest_first_number = {1, 2, 3}
local chest_rupee_number = {1, 2, 3, 4, 5, 6}
local chests_to_open = 0

function map:on_started()
  math.randomseed(os.time())
  chest_1.on_opened = open_chest
  chest_2.on_opened = open_chest
  chest_3.on_opened = open_chest
  chest_4.on_opened = open_chest
  chest_5.on_opened = open_chest
  chest_6.on_opened = open_chest
  chest_7.on_opened = open_chest
  chest_8.on_opened = open_chest
  chest_10.on_opened = open_chest
  chest_11.on_opened = open_chest
  chest_12.on_opened = open_chest
  chest_13.on_opened = open_chest
  chest_14.on_opened = open_chest
  chest_16.on_opened = open_chest
  chest_17.on_opened = open_chest
  chest_18.on_opened = open_chest
  chest_19.on_opened = open_chest
  chest_21.on_opened = open_chest
  chest_23.on_opened = open_chest
end

function thief:on_interaction()
  if game_played == true then
    game:start_dialog("A1.game_of_thieves.played")
  elseif playing_game == true then
    chests_to_open = 3 - chests_opened
    if chests_to_open >= 2 then
      game:start_dialog("A1.game_of_thieves.chests_to_open", chests_to_open, function()
      end)
    else
      game:start_dialog("A1.game_of_thieves.chests_to_open_singular", chests_to_open, function()
      end)
    end
  else
    game:start_dialog("A1.game_of_thieves.introduction", do_you_want_to_play)
  end
end

function do_you_want_to_play()
  game:start_dialog("A1.game_of_thieves.do_you_want_to_play", question_finished)
end

function question_finished(answer)
-- Player does not want to play the game
  if answer == 1 then
    game:start_dialog("A1.game_of_thieves.not_playing")
  else
-- Player wants to play the game
    if game:get_money() < 100 then
      sol.audio.play_sound("wrong")
      game:start_dialog("A1.game_of_thieves.not_enough_money")
    else
      game:remove_money(100)
      game:start_dialog("A1.game_of_thieves.good_luck")
      playing_game = true
    end
  end
end

function open_chest(chest)
  local number = 0
  if chests_opened == 3 then
    chest:set_open(false)
    sol.audio.play_sound("wrong")
    game:start_dialog("A1.game_of_thieves.already_played")
    hero:unfreeze()
  else
    if not playing_game then
      chest:set_open(false)
      sol.audio.play_sound("wrong")
      game:start_dialog("A1.game_of_thieves.pay_up_first")
      hero:unfreeze()
    else
      local random_number = math.random(#chest_first_number) -- choose random number
      local number = chest_first_number[random_number]
      if number == 1 then -- number identifies item (arrow, bomb, or rupee)
        chest_arrow()
      elseif number == 2 then
        chest_bomb()
      elseif number == 3 then
        chest_rupee()
      end
    end
  end
end

function chest_arrow()
  if game:has_item("bow") then
    local random_number = math.random(#chest_first_number)
    local number = chest_first_number[random_number]
    if number == 1 then -- number identifies variant of item
      hero:start_treasure("arrow", 1)
    elseif number == 2 then
      hero:start_treasure("arrow", 2)
    elseif number == 3 then
      hero:start_treasure("arrow", 3)
    end
  else
    hero:start_treasure("rupee", 1)
  end
  chests_opened = chests_opened + 1
  check_if_finished()
end

function chest_bomb()
  if game:has_item("bombs_counter") then
    local random_number = math.random(#chest_first_number)
    local number = chest_first_number[random_number]
    if number == 1 then
      hero:start_treasure("bomb", 1)
    elseif number == 2 then
      hero:start_treasure("bomb", 2)
    elseif number == 3 then
      hero:start_treasure("bomb", 3)
    end
  else
    hero:start_treasure("rupee", 1)
  end
  chests_opened = chests_opened + 1
  check_if_finished()
end

function chest_rupee()
  local random_number = math.random(#chest_rupee_number)
  local number = chest_rupee_number[random_number]
  if number == 1 then
    hero:start_treasure("rupee", 1)
  elseif number == 2 then
    hero:start_treasure("rupee", 2)
  elseif number == 3 then
    hero:start_treasure("rupee", 3)
  elseif number == 4 then
    hero:start_treasure("rupee", 4)
  elseif number == 5 then
    hero:start_treasure("rupee", 5)
  elseif number == 6 then
    hero:start_treasure("rupee", 6)
  end
  chests_opened = chests_opened + 1
  check_if_finished()
end

function check_if_finished()
  if chests_opened == 3 then
    game_played = true
    playing_game = false
  end
end

function leaving_game_sensor:on_activated()
  if playing_game == true then
    game:start_dialog("A1.game_of_thieves.prevent_leaving")
    hero:walk("22")
  end
end