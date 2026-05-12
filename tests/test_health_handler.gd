extends GutTest 

 

var hh: HealthHandler 

 

func before_each(): 
	
	hh = load("res://logic/gameplay_elements/health_handler/health_handler.tscn").instantiate()
	add_child(hh)
	hh.hp = 100 
	
	hh.max_hp = 100 

 

func after_each(): 
	
	hh.free() 

 

func test_take_damage_reduces_hp(): 
	
	hh.take_damage(30) 
	
	await get_tree().process_frame
	
	assert_eq(hh.hp, 70.0, "HP turi būti 70 po 30 žalos") 

 

func test_zero_damage_no_change(): 
	
	hh.take_damage(0) 
	await get_tree().process_frame
	assert_eq(hh.hp, 100.0, "Nulinė žala neturi keisti HP") 

 

func test_hp_does_not_go_below_zero(): 
	
	hh.take_damage(9999) 
	await get_tree().process_frame
	assert_eq(hh.hp, 0.0, "HP negali būti neigiamas") 

 

func test_died_signal_emitted(): 
	
	watch_signals(hh) 
	
	hh.hp = 10 
	
	hh.take_damage(10) 
	await get_tree().process_frame
	assert_signal_emitted(hh, "died") 
	
	 

func test_took_damage_signal_emitted(): 
	
	watch_signals(hh) 
	
	hh.take_damage(1) 
	await get_tree().process_frame
	assert_signal_emitted(hh, "took_damage") 

 

func test_physical_resistance_reduces_damage(): 
	
	hh.resistances["physical"] = 0.5 
	
	hh.take_damage(100, "physical") 
	await get_tree().process_frame
	
	assert_almost_eq(hh.hp, 50.0, 0.01) 
