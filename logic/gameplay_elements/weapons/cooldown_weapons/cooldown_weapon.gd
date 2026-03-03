## Weapon class which has cooldown and damage properties
class_name CooldownWeapon
extends Node2D

var damage : float = 50

var cooldown : float = 0.7
var cooldown_timer : Timer
var projectile_speed : float = 25.0

func _ready() -> void:
	cooldown_timer = Timer.new()
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = false
	add_child(cooldown_timer)
	cooldown_timer.start(cooldown)
	cooldown_timer.timeout.connect(on_cooldown_reached)
	

func on_cooldown_reached()->void:
	pass
	print("cooldown_reached")
	
	
