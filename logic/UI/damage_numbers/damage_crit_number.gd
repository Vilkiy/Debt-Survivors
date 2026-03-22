class_name DamageCritNumber
extends Control

@onready var label: Label = $damage_crit_number

static var z_counter: int = 10

var float_speed: float = 60.0
var lifetime: float = 0.8
var timer: float = 0.0

func setup(amount: float) -> void:
	z_index = z_counter
	z_counter += 1
	label.text = str(int(amount)) + "!"
	label.position.x += randf_range(-40.0, 40.0)
	label.position.y += randf_range(-10.0, 10.0)

func _process(delta: float) -> void:
	timer += delta
	position.y -= float_speed * delta

	var progress = timer / lifetime
	modulate.a = 1.0 - progress
	var new_scale = 1.0 - progress * 0.5
	scale = Vector2.ONE * new_scale

	if timer >= lifetime:
		queue_free()
