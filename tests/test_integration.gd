extends GutTest 

 

func test_player_receives_damage(): 
	
	var player = preload("res://logic/playable_characters/Shotgun_Character.tscn").instantiate() 
	
	add_child_autofree(player) 
	
	await get_tree().process_frame 
	
	var hp_before = player.health_handler.hp 
	
	player.health_handler.take_damage(50) 
	await get_tree().process_frame
	
	assert_almost_eq(player.health_handler.hp, hp_before - 50, 0.01) 

 

func test_xp_collect_increases_xp(): 
	
	var player = preload("res://logic/playable_characters/Shotgun_Character.tscn").instantiate() 
	
	add_child_autofree(player) 
	
	await get_tree().process_frame 
	
	player.current_xp = 0 
	
	player.current_xp += 50
	
	assert_eq(player.current_xp, 50) 
