class_name ProjectileShooter
extends CooldownWeapon

const PROJECTILE :PackedScene = preload("uid://dxy5srsogv3fn")
@onready var range_area: Area2D = $Range

var spread_angle: float = 15.0  # degrees
var projectile_count: int = 1

var ad_scaling: float = 1.0  # 100% AD scaling

func update_damage(attack_damage: float) -> void:
	damage = attack_damage * ad_scaling

func _ready() -> void:
	cooldown = 0.7
	projectile_speed = 2000
	super._ready()

func on_cooldown_reached()->void:
	var enemies : Array[Node2D] = range_area.get_overlapping_bodies().filter(func(a)->bool: return a is Enemy )
	if enemies.is_empty():
		return
	
	
	var closest: Enemy = null
	var best_dist_sq := INF
	
	for e: Enemy in enemies:
		if e == null or not is_instance_valid(e):
			continue
		if e.dead:
			continue
		
		
		var d_sq := global_position.distance_squared_to(e.global_position)
		if d_sq < best_dist_sq:
			best_dist_sq = d_sq
			closest = e
	
	if closest:
		for i in projectile_count:
			var projectile: Projectile = PROJECTILE.instantiate()
			GlobalVar.game_handler.add_child(projectile)
			projectile.global_position = global_position

			var base_direction = (closest.global_position - projectile.global_position).normalized()
			var offset_radians = deg_to_rad(randf_range(-spread_angle, spread_angle))
			projectile.direction = base_direction.rotated(offset_radians)

			projectile.speed = projectile_speed
			projectile.damage = damage
		
		
		
		
		
	
	
	
