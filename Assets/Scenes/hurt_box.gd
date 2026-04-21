extends Area2D
@onready var player: Player = $".."
@onready var invincibility_timer: Timer = $InvincibilityTimer

func _ready() -> void:
	pass
	
	


func _on_body_entered(body: Node2D) -> void:
	if not invincibility_timer.is_stopped():
		return
	
	
	if body is Enemy:
		player.health_handler.take_damage(body.damage, "physical", false)
		invincibility_timer.start()
		
	
