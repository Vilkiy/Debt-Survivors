extends Camera2D

@export var mouse_follow_strength := 0.3
@export var smooth_speed := 6.0

@onready var player = get_parent()

func _process(delta):
	if player == null:
		return

	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - player.global_position
	var target_position = player.global_position + direction * mouse_follow_strength
	
	global_position = global_position.lerp(target_position, smooth_speed * delta)
