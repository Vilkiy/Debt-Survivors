extends CanvasLayer
@onready var time_label: Label = $ColorRect/VBoxContainer/TimeLabel
@onready var level_label: Label = $ColorRect/VBoxContainer/LevelLable

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	
	var time := 0.0
	var level := 1
	if GlobalVar.player:
		level = GlobalVar.player.current_level
		
	if GlobalVar.game_handler:
		time = GlobalVar.game_handler.run_time
		
	time_label.text = _format_time(time)
	level_label.text = "Level: " + str(level)

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://logic/game_handler/game_handler.tscn")

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://logic/UI/main_menu/main_menu.tscn")


func _format_time(time: float) -> String:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	return "Time survived: %02d:%02d" % [minutes, seconds]
