class_name HealthHandler
extends Node

@export var hp : float = 100
var max_hp : float

signal died
signal took_damage

func _ready() -> void:
	max_hp = hp


func take_damage(damage_amount : float)->void:
	if damage_amount > 0.0:
		took_damage.emit()
	
	
	hp = clampf(hp - damage_amount,0.0,max_hp)
	
	if hp <= 0.0:
		die()
	




func die()->void:
	died.emit()
	
