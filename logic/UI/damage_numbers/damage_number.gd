class_name DamageNumber
extends Control

@onready var label: Label = $damage_number

static var z_counter: int = 10

var float_speed: float = 60.0
var lifetime: float = 0.8
var timer: float = 0.0

func setup(amount: float, damage_type: String = "physical", is_crit: bool = false) -> void:
	z_index = z_counter
	z_counter += 1

	label.text = str(int(amount))

	# DAMAGE TYPE COLOR
	match damage_type:
		"physical":
			label.modulate = Color.RED

		"magic":
			label.modulate = Color.BLUE

		_:
			label.modulate = Color.WHITE

	# CRIT OVERRIDE (keeps your old logic)
	if is_crit:
		label.text += "!"
		label.modulate = Color.ORANGE
		scale = Vector2(1.5, 1.5)

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
