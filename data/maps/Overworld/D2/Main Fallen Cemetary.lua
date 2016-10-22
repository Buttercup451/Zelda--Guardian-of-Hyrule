local map = ...
local game = map:get_game()

function welcome:on_interaction()
  game:start_dialog("D2.welcome", question_finished)
end

function question_finished(answer)
  --Player wants to read about the cemetary
  if answer ~= 1 then
    game:start_dialog("D2.welcome.information")
  end  
end