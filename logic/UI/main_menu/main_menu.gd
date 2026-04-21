extends Control

func _on_start_pressed():
	var hero_scene = $HeroSelection/heroSelection.get_selected_hero_scene()
	GameConfig.selected_hero = hero_scene
	get_tree().change_scene_to_file("res://logic/game_handler/game_handler.tscn")

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://logic/UI/main_menu/settings_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
