class_name HUD
extends CanvasLayer

@onready var level_label: Label = $VBoxContainer/LevelLabel
@onready var xp_bar: ProgressBar = $Control/XPBar

func update(current_xp: int, xp_to_level_up: int, current_level: int) -> void:
	level_label.text = "Level: " + str(current_level)
	xp_bar.max_value = xp_to_level_up
	xp_bar.value = current_xp
