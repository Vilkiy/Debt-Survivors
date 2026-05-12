extends GutTest 

 

var weapon: CooldownWeapon 

 

func before_each(): 
	
	GlobalVar.player = load("res://logic/playable_characters/Sword_Character.tscn").instantiate()
	
	weapon = CooldownWeapon.new() 

 

func after_each(): 
	
	weapon.free() 
	GlobalVar.player.free()
	

 

func test_crit_chance_zero_never_crits(): 
	
	GlobalVar.player.crit_chance = 0.0
	
	for i in 100: 
		
		var result = weapon.roll_crit(100.0) 
		
		
		assert_false(result["is_crit"]) 
		
	
	

 

func test_crit_chance_one_always_crits(): 
	
	GlobalVar.player.crit_chance = 1.0
	
	var result = weapon.roll_crit(100.0) 
	
	assert_true(result["is_crit"]) 
	
	assert_almost_eq(result["damage"], 150.0, 0.01) 

 

func test_crit_damage_is_1_5x(): 
	
	GlobalVar.player.crit_chance = 1.0
	
	var result = weapon.roll_crit(200.0) 
	
	assert_almost_eq(result["damage"], 300.0, 0.01) 
	
	
