class_name SwordWeapon
extends CooldownWeapon

@onready var sword_left: Area2D = $SwordLeft
@onready var sword_right: Area2D = $SwordRight

var swing_count: int = 0
var ad_scaling: float = 1.2

var speed_boost_amount: float = 200.0
var speed_boost_duration: float = 1.5
var _boost_timer: float = 0.0
var _is_boosting: bool = false

func update_damage(attack_damage: float) -> void:
	damage = attack_damage * ad_scaling

func _ready() -> void:
	cooldown = 0.9
	sword_left.monitoring = true
	sword_right.monitoring = true
	sword_left.get_node("Polygon2D").visible = false
	sword_right.get_node("Polygon2D").visible = false
	_flash_timer = Timer.new()
	_flash_timer.one_shot = true
	add_child(_flash_timer)
	_flash_timer.timeout.connect(_on_flash_timeout)
	super._ready()


func _process(delta: float) -> void:
	if _is_boosting:
		_boost_timer -= delta
		if _boost_timer <= 0.0:
			_is_boosting = false
			GlobalVar.player.speed -= speed_boost_amount

var _is_swinging: bool = false

func on_cooldown_reached() -> void:
	var closest := _get_closest_enemy()
	if closest == null:
		return

	swing_count += 1
	var is_odd := swing_count % 2 == 1
	var hitbox: Area2D = sword_left if is_odd else sword_right
	var other: Area2D = sword_right if is_odd else sword_left

	other.monitoring = false

	var dir := (closest.global_position - global_position).normalized()
	hitbox.position = dir * 50.0
	hitbox.rotation = dir.angle() + PI / 2

	hitbox.monitoring = false
	await get_tree().process_frame
	hitbox.monitoring = true

	_is_swinging = true
	_flash_hitbox(hitbox)
	await get_tree().create_timer(0.15).timeout
	_is_swinging = false

func _get_closest_enemy() -> Enemy:
	var closest: Enemy = null
	var best_dist := INF
	for body in get_tree().get_nodes_in_group("enemy"):
		if body is Enemy and not body.dead:
			var d: float = body.global_position.distance_to(global_position)
			if d < best_dist:
				best_dist = d
				closest = body
	return closest

func _get_overlapping_enemies(hitbox: Area2D) -> Array:
	return hitbox.get_overlapping_bodies().filter(func(b): return b is Enemy)

func _apply_speed_boost() -> void:
	if not _is_boosting:
		GlobalVar.player.speed += speed_boost_amount
	_is_boosting = true
	_boost_timer = speed_boost_duration

func _on_sword_left_body_entered(body: Node2D) -> void:
	if not _is_swinging or not body is Enemy or not is_instance_valid(body):
		return
	var is_crit := randf() < GlobalVar.player.crit_chance
	var final_damage := damage * 3.0 if is_crit else damage
	body.health_handler.take_damage(final_damage, "physical", is_crit)
	
func _on_sword_right_body_entered(body: Node2D) -> void:
	if not _is_swinging or not body is Enemy or not is_instance_valid(body):
		return
	var result := roll_crit(damage)
	body.health_handler.take_damage(result["damage"], "physical", result["is_crit"])
	_apply_speed_boost()
		
var _flash_timer: Timer

var _active_flash_hitbox: Area2D = null

func _flash_hitbox(hitbox: Area2D) -> void:
	_active_flash_hitbox = hitbox
	hitbox.get_node("Polygon2D").visible = true
	_flash_timer.start(0.12)

func _on_flash_timeout() -> void:
	if _active_flash_hitbox:
		_active_flash_hitbox.get_node("Polygon2D").visible = false
		_active_flash_hitbox = null
