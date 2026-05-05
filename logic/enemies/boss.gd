extends Enemy

func _ready():
	hp = 10000
	max_hp = 10000
	speed = 120
	damage = 20
	xpAmount = 100
	
	health_handler.resistances["physical"] = 0.1
	health_handler.resistances["magic"] = 0.0
	super()
	
	call_deferred("_register_boss")

func _register_boss() -> void:
	var hud = get_tree().root.find_child("HUD", true, false)
	if hud:
		hud.show_boss(self)
