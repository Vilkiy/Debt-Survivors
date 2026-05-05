extends Camera2D

@export var smooth_speed := 6.0
@export var look_ahead_strength := 1.0
@export var return_speed := 4.0

var shake_strength := 0.0
var shake_decay := 8.0
var shake_timer := 0.0
var shake_offset := Vector2.ZERO
@onready var player = get_parent()

var look_offset := Vector2.ZERO

func add_shake(intensity: float, duration: float) -> void:
	shake_strength = max(shake_strength, intensity)
	shake_timer = duration

func _process(delta):
	if player == null:
		return

	var input_dir := Vector2.ZERO

	# ----------------------------
	# INPUT (look-ahead system)
	if Input.is_action_pressed("move_up"):
		input_dir.y -= 1
	if Input.is_action_pressed("move_down"):
		input_dir.y += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1

	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		var target_offset = input_dir * 100 * look_ahead_strength
		look_offset = look_offset.lerp(target_offset, smooth_speed * delta)
	else:
		look_offset = look_offset.lerp(Vector2.ZERO, return_speed * delta)

	# ----------------------------
	# BASE CAMERA POSITION (no shake yet)
	var target_position = player.global_position + look_offset
	var base_position = global_position.lerp(target_position, smooth_speed * delta)

	# ----------------------------
	# CAMERA SHAKE (added on top)
	if shake_timer > 0.0:
		shake_timer -= delta

		var intensity_curve = shake_timer / max(shake_timer + 0.0001, 0.0001)

		var random_offset = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		)

		shake_offset = random_offset * shake_strength * 10.0
	else:
		shake_offset = Vector2.ZERO

	# ----------------------------
	# FINAL OUTPUT
	global_position = base_position + shake_offset
