class_name Player
extends CharacterBody2D

@export var attack_damage_base: float = 100.0
var attack_damage_multiplier: float = 1.0
var crit_chance: float = 0.0

var attack_damage: float:
	get:
		return attack_damage_base * attack_damage_multiplier
@export var speed := 200.0
@onready var health_handler: HealthHandler = $HealthHandler
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var current_xp: int = 0
var current_level : int = 1
var xp_to_level_up : int = 100

@export var knockback_strength := 350.0  # pixels per second
var knockback_velocity := Vector2.ZERO
var knockback_friction := 10.0  # how fast knockback slows down

@export var dash_distance := 200.0     # total distance of dash
@export var dash_duration := 0.15      # how long the dash lasts (seconds)
@export var dash_cooldown := 1.0
var dash_timer := 0.0
var is_dashing := false
var dash_direction := Vector2.ZERO
var dash_time_left := 0.0              # timer for dash duration
var hud: HUD

const UPGRADE_SCREEN = preload("uid://b8js13fbvbdnw")

func _ready() -> void:
	GlobalVar.player = self
	await get_tree().process_frame
	hud = get_tree().root.find_child("HUD", true, false)
	recalculate_weapon_damages()
	animated_sprite_2d.play("idle")


func _physics_process(_delta):
	# ----------------------------
	# Update dash cooldown timer
	if dash_timer > 0.0:
		dash_timer -= _delta
# Update HUD so cooldown label is live
	health_handler.update_dash_cooldown(dash_timer, dash_cooldown)

	var dir := Vector2.ZERO

	# ----------------------------
	# Dash input
	if Input.is_action_just_pressed("dash") and dash_timer <= 0.0 and not is_dashing:
		is_dashing = true
		dash_time_left = dash_duration
		dash_direction = Vector2.ZERO

		if Input.is_action_pressed("move_up"):
			dash_direction.y -= 1
		if Input.is_action_pressed("move_down"):
			dash_direction.y += 1
		if Input.is_action_pressed("move_left"):
			dash_direction.x -= 1
		if Input.is_action_pressed("move_right"):
			dash_direction.x += 1

		if dash_direction == Vector2.ZERO:
			dash_direction = velocity.normalized()
		else:
			dash_direction = dash_direction.normalized()

		dash_timer = dash_cooldown

	# ----------------------------
	# Normal movement or dash
	if is_dashing:
		# Smooth dash velocity
		var dash_speed = dash_distance / dash_duration
		velocity = dash_direction * dash_speed + knockback_velocity

		dash_time_left -= _delta
		if dash_time_left <= 0.0:
			is_dashing = false
	else:
		if Input.is_action_pressed("move_up"):
			dir.y -= 1
		if Input.is_action_pressed("move_down"):
			dir.y += 1
		if Input.is_action_pressed("move_left"):
			dir.x -= 1
		if Input.is_action_pressed("move_right"):
			dir.x += 1
		
		if dir != Vector2.ZERO:
			dir = dir.normalized()
		velocity = dir * speed + knockback_velocity
	
	if dir.length() >0:
		animated_sprite_2d.play("forward")
		if dir.x <0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
		
	else:
		animated_sprite_2d.play("idle")
	
	# ----------------------------
	move_and_slide()
	
	# Decay knockback over time
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_friction)
	



func deal_knockback(attacker_global_position: Vector2) -> void:
	var direction = (global_position - attacker_global_position).normalized()
	knockback_velocity = direction * knockback_strength
	
	

func _on_health_handler_took_damage() -> void:
	pass
	# Calculate direction away from enemy
	#var direction = (global_position - attacker_global_position).normalized()
	#knockback_velocity = direction * knockback_strength
	#print("player took damage: " + str(health_handler.hp))


func collect_xp(amount: int) -> void:
	current_xp += amount
	if hud:
		hud.update(current_xp, xp_to_level_up, current_level, attack_damage)
	if current_xp >= xp_to_level_up:
		_level_up()



func _level_up() -> void:
	current_level += 1
	xp_to_level_up = ceil(1.2 * xp_to_level_up)
	current_xp = 0
	if hud:
		hud.update(current_xp, xp_to_level_up, current_level, attack_damage)
	
	var screen = UPGRADE_SCREEN.instantiate()
	get_tree().root.add_child(screen)
	screen.show_upgrades(self)
	screen.upgrade_chosen.connect(func():
		get_tree().paused = false
		screen.queue_free()
	)
	get_tree().paused = true
	
func recalculate_weapon_damages() -> void:
	for weapon in get_node("Weapons").get_children():
		if weapon.has_method("update_damage"):
			weapon.update_damage(attack_damage)
	if hud:
		hud.update(current_xp, xp_to_level_up, current_level, attack_damage)
