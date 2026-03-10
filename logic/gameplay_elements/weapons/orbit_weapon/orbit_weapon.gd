class_name OrbitWeapon
extends Node2D

const ORB = preload("res://logic/gameplay_elements/weapons/orbit_weapon/orb/orb.tscn")

var orb_count: int = 1
var orbit_radius: float = 80.0
var orbit_speed: float = 2.0  # radians per second
var angle: float = 0.0
var orbs: Array = []

func _ready() -> void:
	print("OrbitWeapon ready, orb count: ", orb_count)
	update_orbs()

func _process(delta: float) -> void:
	angle += orbit_speed * delta
	for i in orbs.size():
		var orb_angle = angle + (TAU / orbs.size()) * i
		orbs[i].global_position = global_position + Vector2(cos(orb_angle), sin(orb_angle)) * orbit_radius

func update_orbs() -> void:
	for orb in orbs:
		orb.queue_free()
	orbs.clear()
	
	for i in orb_count:
		var orb = ORB.instantiate()
		get_tree().root.get_child(0).add_child(orb)
		orbs.append(orb)
