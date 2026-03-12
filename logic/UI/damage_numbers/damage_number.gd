class_name DamageNumber
extends Control

@onready var label: Label = $Label

static var z_counter: int = 10

var float_speed: float = 60.0
var lifetime: float = 0.8
var timer: float = 0.0

# TO DO FIGURE OUT HOW TO ADD STROKE

func setup(amount: float) -> void:
	z_index = z_counter
	z_counter += 1
	label.text = str(int(amount))
	label.position.x += randf_range(-40.0, 40.0)
	label.position.y += randf_range(-10.0, 10.0)

func _process(delta: float) -> void:
	timer += delta
	position.y -= float_speed * delta
	
	var progress = timer / lifetime  # goes from 0.0 to 1.0
	modulate.a = 1.0 - progress
	var new_scale = 1.0 - progress * 0.5
	scale = Vector2.ONE * new_scale
	
	if timer >= lifetime:
		queue_free()
