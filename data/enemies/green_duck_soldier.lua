local enemy = ...

-- Green duck soldier.

sol.main.load_file("enemies/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/green_duck_soldier",
  sword_sprite = "enemies/green_duck_soldier_sword",
  life = 4,
  damage = 8,
  hurt_style = "monster",
  play_hero_seen_sound = true
  normal_speed = 32
  faster_speed = 64
})

function enemy:on_position_changed()
 bunny_form = enemy:get_game():get_value("bunny")
  if bunny_form == true then
    properties.normal_speed = 0
    properties.faster_speed = 0
    properties.play_hero_seen_sound = false
  else
    properties.normal_speed = enemy:get_game():get_value("generic_soldier_normal_speed")
    properties.faster_speed = enemy:get_game():get_value("generic_soldier_faster_speed")
    properties.play_hero_seen_sound = true
  end
end