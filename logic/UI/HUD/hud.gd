class_name HUD
extends CanvasLayer

@onready var level_label: Label = $VBoxContainer/LevelLabel
@onready var xp_bar: ProgressBar = $Control/XPBar
@onready var ad_label: Label = $VBoxContainer/ADLabel

func update(current_xp: int, xp_to_level_up: int, current_level: int, attack_damage: float) -> void:
	level_label.text = "Level: " + str(current_level)
	xp_bar.max_value = xp_to_level_up
	xp_bar.value = current_xp
	ad_label.text = "AD: " + str(attack_damage)
