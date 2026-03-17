extends Camera2D

@export var smooth_speed := 6.0
@export var look_ahead_strength := 1.0
@export var return_speed := 4.0

@onready var player = get_parent()

var look_offset := Vector2.ZERO

func _process(delta):
	if player == null:
		return

	var input_dir := Vector2.ZERO

	# Read raw input (NOT velocity)
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
		# Return to center when no input
		look_offset = look_offset.lerp(Vector2.ZERO, return_speed * delta)

	var target_position = player.global_position + look_offset
	global_position = global_position.lerp(target_position, smooth_speed * delta)
