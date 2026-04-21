class_name XP
extends Area2D

@export var value : int = 50
func _ready() -> void:
	pass





func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.collect_xp(value)
		UpgradeCurrencyManager.add_coins(value / 10) 
		queue_free()
