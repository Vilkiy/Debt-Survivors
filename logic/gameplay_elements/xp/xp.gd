class_name XP
extends Area2D

# Called when the node enters the scene tree for the first time.
@export var value : int = 5
func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
	



func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		body.collect_xp(value)
		queue_free()
