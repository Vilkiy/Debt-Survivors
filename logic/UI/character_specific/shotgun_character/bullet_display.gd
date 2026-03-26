extends Node2D

const PIP_WIDTH: float = 14.0
const PIP_HEIGHT: float = 20.0
const PIP_GAP: float = 6.0
const OFFSET_Y: float = -80.0

var pip_backgrounds: Array = []
var pip_fills: Array = []

func setup(max_ammo: int) -> void:
	for child in get_children():
		child.queue_free()
	pip_backgrounds.clear()
	pip_fills.clear()

	var total_width = max_ammo * PIP_WIDTH + (max_ammo - 1) * PIP_GAP
	var start_x = -total_width / 2.0

	for i in max_ammo:
		var x = start_x + i * (PIP_WIDTH + PIP_GAP)

		var bg = ColorRect.new()
		bg.size = Vector2(PIP_WIDTH, PIP_HEIGHT)
		bg.position = Vector2(x, OFFSET_Y - PIP_HEIGHT)
		bg.color = Color(0.3, 0.3, 0.3, 0.9)
		add_child(bg)
		pip_backgrounds.append(bg)

		var fill = ColorRect.new()
		fill.size = Vector2(PIP_WIDTH, 0.0)
		fill.position = Vector2(x, OFFSET_Y)
		fill.color = Color(1.0, 0.85, 0.1, 1.0)
		add_child(fill)
		pip_fills.append(fill)

func update_display(current_ammo: int, max_ammo: int, reload_progress: float, reload_time: float) -> void:
	if pip_fills.size() != max_ammo:
		setup(max_ammo)

	for i in max_ammo:
		if i < current_ammo:
			# Full — yellow all the way up
			pip_fills[i].size.y = PIP_HEIGHT
			pip_fills[i].position.y = OFFSET_Y - PIP_HEIGHT
		else:
			# Reloading — fill grows bottom to top
			var fill_ratio: float = clampf(reload_progress / reload_time, 0.0, 1.0)
			var fill_h = PIP_HEIGHT * fill_ratio
			pip_fills[i].size.y = fill_h
			pip_fills[i].position.y = OFFSET_Y - fill_h
