extends Enemy

func _ready():
	hp = 1000
	max_hp = 1000
	speed = 100
	damage = 10
	xpAmount = 40
	
	health_handler.resistances["physical"] = 0.2
	health_handler.resistances["magic"] = 0.0

	super()
