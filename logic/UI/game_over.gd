extends CanvasLayer

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://logic/game_handler/game_handler.tscn")

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://logic/UI/main_menu/main_menu.tscn")
