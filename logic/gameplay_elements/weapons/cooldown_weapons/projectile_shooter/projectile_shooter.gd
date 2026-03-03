class_name ProjectileShooter
extends CooldownWeapon

const PROJECTILE :PackedScene = preload("uid://dxy5srsogv3fn")
@onready var range_area: Area2D = $Range



func _ready() -> void:
	damage = 25.0
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
			return
		
		
		var d_sq := global_position.distance_squared_to(e.global_position)
		if d_sq < best_dist_sq:
			best_dist_sq = d_sq
			closest = e
	
	if closest:
		var projectile : Projectile = PROJECTILE.instantiate()
		
		GlobalVar.game_handler.add_child(projectile)
		projectile.global_position = global_position
		projectile.direction = (closest.global_position - projectile.global_position).normalized()
		projectile.speed = projectile_speed
		projectile.damage = damage
		
		
		
		
		
	
	
	
