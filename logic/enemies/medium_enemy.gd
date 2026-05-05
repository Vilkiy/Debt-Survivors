extends Enemy

func _ready():
	max_hp = 400
	hp = 400
	speed = 140
	damage = 7
	xpAmount = 20
	
	health_handler.resistances["physical"] = 0.07
	health_handler.resistances["magic"] = 0.0
	
	super()
