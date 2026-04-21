class_name GameHandler
extends Node

const GAME_OVER_SCREEN = preload("res://logic/UI/game_over.tscn")

func _ready() -> void:
	GlobalVar.game_handler = self
	var player_scene = load(GameConfig.selected_hero)
	var player = player_scene.instantiate()
	add_child(player)
	await get_tree().process_frame
	GlobalVar.player.health_handler.died.connect(_on_player_died)

func _on_player_died() -> void:
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout;
	var game_over = GAME_OVER_SCREEN.instantiate()
	add_child(game_over)
