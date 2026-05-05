class_name XP
extends Area2D

@export var value: int = 50

@export var pickup_radius: float = 200.0
@export var move_speed: float = 0.0
@export var acceleration: float = 1200.0
@export var max_speed: float = 700.0

var player: Node2D


func _ready() -> void:
	await get_tree().process_frame
	player = GlobalVar.player


func _physics_process(delta: float) -> void:
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	# ----------------------------
	# MAGNET BEHAVIOR
	if distance < pickup_radius:
		move_speed = min(move_speed + acceleration * delta, max_speed)

		var dir = (player.global_position - global_position).normalized()
		global_position += dir * move_speed * delta
	else:
		# reset when outside range
		move_speed = 0.0


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.collect_xp(value)
		UpgradeCurrencyManager.add_coins(value / 10)
		queue_free()
