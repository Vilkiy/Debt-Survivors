class_name OrbitWeapon
extends Node2D

const ORB = preload("res://logic/gameplay_elements/weapons/orbit_weapon/orb/orb.tscn")

var orb_count: int = 1
var orbit_radius: float = 160.0
var orbit_speed: float = 2.0  # radians per second
var angle: float = 0.0
var orbs: Array = []
var ad_scaling: float = 2.0  # 200% AD scaling

func update_damage(attack_damage: float) -> void:
	var new_damage = attack_damage * ad_scaling
	for orb in orbs:
		orb.damage = new_damage


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
		add_child(orb)  # parent to OrbitWeapon, not the root
		orbs.append(orb)
	
	var player = GlobalVar.player
	if player:
		update_damage(player.attack_damage)
