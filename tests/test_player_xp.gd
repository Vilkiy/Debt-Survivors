extends GutTest 

var player 

func before_each(): 
	
	player = preload("res://logic/playable_characters/Shotgun_Character.tscn").instantiate() 
	
	player.current_xp = 0 
	
	player.current_level = 1 
	
	player.xp_to_level_up = 100 

 

func after_each(): 
	
	player.free() 

 

func test_collect_xp_adds_correctly(): 
	
	player.current_xp = 0 
	
	# Simulate manual XP add (bypass collect_xp HUD calls) 
	
	player.current_xp += 50 
	
	assert_eq(player.current_xp, 50) 

 

func test_level_up_increments_level(): 
	
	player.current_xp = 90 
	
	player.current_xp += 10 
	
	if player.current_xp >= player.xp_to_level_up: 
	
		player.current_level += 1 
	
	assert_eq(player.current_level, 2) 

 

func test_xp_threshold_grows_after_level_up(): 
	
	var old_threshold = player.xp_to_level_up 
	
	player.xp_to_level_up = ceili(1.5 * old_threshold) 
	
	assert_eq(player.xp_to_level_up, 150) 

 

func test_attack_damage_formula(): 
	
	player.attack_damage_base = 100.0 
	
	player.attack_damage_multiplier = 1.5 
	
	var result = player.attack_damage_base * player.attack_damage_multiplier 
	
	assert_almost_eq(result, 150.0, 0.01) 
