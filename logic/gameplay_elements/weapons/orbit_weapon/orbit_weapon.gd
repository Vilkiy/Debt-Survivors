class_name OrbitWeapon
extends Node2D

const ORB = preload("res://logic/gameplay_elements/weapons/orbit_weapon/orb/orb.tscn")

var orb_count: int = 1
var orbit_radius: float = 80.0
var orbit_speed: float = 2.0
var angle: float = 0.0
var orbs: Array = []
var ad_scaling: float = 2.0
#var crit_chance: float = 0.1  # 10% base

func update_damage(attack_damage: float) -> void:
	var new_damage = attack_damage * ad_scaling
	for orb in orbs:
		orb.damage = new_damage

func _ready() -> void:
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
		add_child(orb)
		orbs.append(orb)

	var player = GlobalVar.player
	if player:
		update_damage(player.attack_damage)
