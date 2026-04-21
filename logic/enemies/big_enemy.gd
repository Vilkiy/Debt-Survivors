extends Enemy

func _ready():
	hp = 1200
	max_hp = 1200
	speed = 100
	damage = 10
	xpAmount = 40
	
	health_handler.resistances["physical"] = 0.2
	health_handler.resistances["magic"] = 0.0

	super()
