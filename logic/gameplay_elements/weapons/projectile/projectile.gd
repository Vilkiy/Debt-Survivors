class_name Projectile
extends Area2D

var damage : float = 25

var speed : float
var direction : Vector2 = Vector2.RIGHT

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.health_handler.take_damage(damage)
		queue_free()
		


func _physics_process(delta: float) -> void:
	
	position += direction * speed * delta
	
	
