extends Control

func _on_start_pressed():
	get_tree().change_scene_to_file("res://logic/game_handler/game_handler.tscn")

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://logic/UI/settings_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
