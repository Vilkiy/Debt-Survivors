extends Area2D

@export var speed: float = 400.0
@export var damage: int = 20
var direction: Vector2 = Vector2.ZERO
var lifetime := 3.0
var timer := 0.0

func _process(delta):
	timer += delta
	if timer >= lifetime:
		queue_free()

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body is Player:
		body.deal_knockback(global_position)
		body.health_handler.take_damage(damage)
		queue_free()
