extends Control

@onready var coin_label: Label = $CurrencyContainer/Currency
"res://logic/game_handler/game_handler.tscn"

@onready var shop: Button = $Menu/Shop

func _ready() -> void:
	coin_label.text = "$ " + str(UpgradeCurrencyManager.coins)

func _on_start_pressed():
	var hero_scene = $HeroSelection/heroSelection.get_selected_hero_scene()
	var arena = $ArenaSelection/arenaSelection.get_selected_arena_scene()
	var waves = $ArenaSelection/arenaSelection.get_selected_arena_waves()
	GameConfig.selected_hero = hero_scene
	GameConfig.selected_arena = arena
	GameConfig.selected_arena_waves = waves
	get_tree().change_scene_to_file("res://logic/game_handler/game_handler.tscn")

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://logic/UI/main_menu/settings_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://logic/UI/main_menu/shop_menu.tscn")
	
