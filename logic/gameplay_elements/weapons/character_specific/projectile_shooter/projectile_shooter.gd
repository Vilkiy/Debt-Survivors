class_name ProjectileShooter
extends CooldownWeapon

const PROJECTILE: PackedScene = preload("res://logic/gameplay_elements/weapons/character_specific/projectile_shooter/projectile/projectile.tscn")
@onready var range_area: Area2D = $Range

@export var spread_angle: float = 20.0
@export var projectile_count: int = 5
var base_damage: float = 0.0 # Placeholder I'll think about it later
@export var ad_scaling: float = 1.5

var max_ammo: int = 2
var current_ammo: int = 2
var reload_time: float = 2.5
var reload_progress: float = 0.0
var is_reloading: bool = false

signal firing

func update_damage(attack_damage: float) -> void:
	damage = base_damage + attack_damage * ad_scaling

func _ready() -> void:
	cooldown = 0.5
	projectile_speed = 2000
	current_ammo = max_ammo
	reload_progress = reload_time
	super._ready()

func _process(delta: float) -> void:
	if is_reloading:
		reload_progress += delta * GlobalVar.player.attack_speed_multiplier
		if reload_progress >= reload_time:
			reload_progress = reload_time
			current_ammo = max_ammo
			is_reloading = false

func on_cooldown_reached() -> void:
	
	if current_ammo <= 0:
		return
	
	var enemies: Array[Node2D] = range_area.get_overlapping_bodies().filter(
		func(a) -> bool: return a is Enemy
	)
	if enemies.is_empty():
		return

	var closest: Enemy = null
	var best_dist_sq := INF
	for e: Enemy in enemies:
		if e == null or not is_instance_valid(e) or e.dead:
			continue
		var d_sq := global_position.distance_squared_to(e.global_position)
		if d_sq < best_dist_sq:
			best_dist_sq = d_sq
			closest = e

	if closest == null:
		return

	var crit_result = roll_crit(damage)

	for i in projectile_count:
		var projectile: Projectile = PROJECTILE.instantiate()
		GlobalVar.game_handler.add_child(projectile)
		projectile.global_position = global_position
		var base_dir = (closest.global_position - global_position).normalized()
		var offset = deg_to_rad(randf_range(-spread_angle, spread_angle))
		projectile.direction = base_dir.rotated(offset)
		projectile.speed = projectile_speed
		projectile.damage = crit_result["damage"]
		projectile.is_crit = crit_result["is_crit"]
	
	print("firing, damage per pellet: ", crit_result["damage"])
	firing.emit()
	
	current_ammo -= 1
	if current_ammo <= 0:
		is_reloading = true
		reload_progress = 0.0

func refill_ammo() -> void:
	current_ammo = max_ammo
	is_reloading = false
	reload_progress = reload_time
