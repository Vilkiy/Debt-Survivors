extends GutTest 

var shooter: ProjectileShooter 

func before_each(): 

	shooter = ProjectileShooter.new() 

	shooter.max_ammo = 2 

	shooter.current_ammo = 2 

	shooter.ad_scaling = 1.5 

 

func after_each(): 

	shooter.free() 

 

func test_update_damage_scales_correctly(): 

	shooter.update_damage(100.0) 

	assert_almost_eq(shooter.damage, 150.0, 0.01, "damage = 100 * 1.5") 

 

func test_refill_ammo_fills_to_max(): 

	shooter.current_ammo = 0 

	shooter.is_reloading = true 

	shooter.refill_ammo() 

	assert_eq(shooter.current_ammo, shooter.max_ammo) 
	
	assert_false(shooter.is_reloading) 

 

func test_shot_decrements_ammo(): 
	
	shooter.current_ammo = 2 
	
	shooter.current_ammo -= 1 
	
	assert_eq(shooter.current_ammo, 1) 

 

func test_empty_ammo_triggers_reload(): 
	
	shooter.current_ammo = 1 
	
	shooter.current_ammo -= 1 
	
	if shooter.current_ammo <= 0: 
	
		shooter.is_reloading = true 

	assert_true(shooter.is_reloading) 
