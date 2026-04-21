extends Enemy

func _ready():
	hp = 400
	max_hp = 400
	speed = 160
	damage = 5
	xpAmount = 10
	
	health_handler.resistances["physical"] = 0.05
	health_handler.resistances["magic"] = 0.0
	
	super()
